using System;
using System.Collections.Generic;
using UnityEngine;
using XLua;

namespace BaseLuaController
{
    public class CSharpCallLuaController : MonoBehaviour
    {
        private string _cSharpCallLuaName = "CSharpCallLua";

        private LuaEnv _luaEnv => xLuaLoaderManager.Instance.LuaEnv;

        private void Start()
        {
            //使用Require 加载Lua 脚本
            _luaEnv.DoString($"require '{_cSharpCallLuaName}'");


            //访问全局变量
            loadGlobalValue();

            loadGlobalByClassAndStruct();

            loadGlobalByInterface();

            loadGlobalByDictionaryAndList();

            loadGlobalByLuaTable();


            //访问全局函数function
            loadFunctionByDelegate();

            loadFunctionByLuaFunction();

            //1.访问lua中的全局数据都是比较消耗性能的,特别是table 和 function,需要尽量少用.
            //在初始化时,把所有需要用到的访问映射下来,后续直接调用就行

            //2.如果lua侧实现的都是以 delegate 和 interface 方式提供的,那么使用上可以完全实现xLua解耦,
            //专门有一个位置进行xLua相关的初始化映射,其他位置直接使用映射出来方法就好了

            //Get<T> 少用
        }

        private void loadGlobalValue()
        {
            //加载全局变量
            int age = _luaEnv.Global.Get<int>("age");

            string name = _luaEnv.Global.Get<string>("name");

            string home = _luaEnv.Global.Get<string>("home");

            Debug.Log($"Name: {name} Age: {age} Home: {home}");
        }


        private void loadGlobalByClassAndStruct()
        {
            //class / struct 使用类和结构体 加载 Table 映射使用
            Person person = _luaEnv.Global.Get<Person>("Person");
            Debug.Log($"Using Class - Name: {person.name} Age: {person.age} Home: {person.home}");

            PersonStruct personStruct = _luaEnv.Global.Get<PersonStruct>("Person");
            Debug.Log($"Using Struct - Name: {personStruct.name} Age: {personStruct.age} Home: {personStruct.home}");

            //Class 是比较消耗性能的,且是值拷贝,修改字段不会同步.
            //[GCOptimize] 效果是该值类型在lua和c#间传递不产生（C#）gc alloc，该类型的数组访问也不产生gc。
            person.name = "Eligos Change New Name";
            _luaEnv.DoString("print('Class: ' .. Person.name)");
        }


        private void loadGlobalByInterface()
        {
            //Interface 使用接口 加载 Table 映射使用
            IPerson iPerson = _luaEnv.Global.Get<IPerson>("Person");
            Debug.Log($"Using Interface - Name: {iPerson.name} Age: {iPerson.age} Home: {iPerson.home}");

            //接口需要添加 [CSharpCallLua],且接口为引用类型,修改是会传递的
            iPerson.name = "Eligos Change New Name";
            _luaEnv.DoString("print('Interface: ' .. Person.name)");

            //无参函数
            iPerson.Eat();

            //有参函数
            iPerson.EatManyFood(10, 20);
        }

        private void loadGlobalByDictionaryAndList()
        {
            //通过 Dictionary | List 访问 Lua
            //Dictionary,只能访问,带有键值对的数据
            Dictionary<string, string> dic = _luaEnv.Global.Get<Dictionary<string, string>>("DictionaryByValue");

            foreach (KeyValuePair<string, string> keyValuePair in dic)
            {
                Debug.Log($"Key: {keyValuePair.Key} Value: {keyValuePair.Value}");
            }

            //List,是能访问里面的值,且通过使用 object,就可以访问包括string , 而int就只访问number类型
            List<int> intList = _luaEnv.Global.Get<List<int>>("ListByValue");

            foreach (int i in intList)
            {
                Debug.Log($"Int List: {i}");
            }

            List<object> objectList = _luaEnv.Global.Get<List<object>>("ListByValue");

            foreach (object i in objectList)
            {
                Debug.Log($"Object List: {i}");
            }

            List<string> stringList = _luaEnv.Global.Get<List<string>>("ListByValue");

            foreach (string i in stringList)
            {
                Debug.Log($"String List: {i}");
            }
        }

        private void loadGlobalByLuaTable()
        {
            //好处是不需要生成代码,但是不interface要慢一个数量级,还没有类型检查
            LuaTable luaTable = _luaEnv.Global.Get<LuaTable>("PersonLuaTable");

            Debug.Log($"lua Table - Name: {luaTable.Get<string>("name")}");
            Debug.Log($"lua Table - Age: {luaTable.Get<int>("age")}");
            Debug.Log($"lua Table - Home: {luaTable.Get<string>("home")}");
        }

        private void loadFunctionByDelegate()
        {
            //不带参数的方法可以直接使用 Action进行接收
            Action action = _luaEnv.Global.Get<Action>("Add");
            action?.Invoke();

            //带参数的方法就不能直接使用Action,需要设置[CSharpCallLua] 的 delegate 实现了
            AddNumber addNumber = _luaEnv.Global.Get<AddNumber>("AddNumber");
            addNumber?.Invoke(10, 23);

            //返回值 默认单个使用 return,其余的可以使用 ref/out 进行接收
            AddNumberReturn addNumberReturn = _luaEnv.Global.Get<AddNumberReturn>("AddNumberReturn");
            int refA = 14, outB;
            int res = addNumberReturn(14, 23, ref refA, out outB);

            Debug.Log($"Return: {res} {refA} {outB}");
        }


        private void loadFunctionByLuaFunction()
        {
            //使用LuaFunction 来访问方法
            LuaFunction luaFunction = _luaEnv.Global.Get<LuaFunction>("AddNumberReturn");
            int refA = 14;
            object[] os = luaFunction.Call(1, 3, refA);

            foreach (object o in os)
            {
                Debug.Log(o);
            }
        }
    }


    [CSharpCallLua]
    public interface IPerson
    {
        string name { get; set; }
        int age { get; set; }
        string home { get; set; }

        void Eat();

        void EatManyFood(int a, int b);
    }


    public class Person
    {
        public string name;
        public int age;
        public string home;
    }

    public struct PersonStruct
    {
        public string name;
        public int age;
        public string home;
    }

    [CSharpCallLua]
    delegate void AddNumber(int a, int b);

    [CSharpCallLua]
    delegate int AddNumberReturn(int a, int b, ref int refA, out int outB);
}