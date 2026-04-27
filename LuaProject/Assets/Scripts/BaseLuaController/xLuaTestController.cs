using System.IO;
using UnityEngine;
using XLua;

namespace BaseLuaController
{
    public class xLuaTestController : MonoBehaviour
    {
        private LuaEnv luaEnv;

        void Start()
        {
            luaEnv = new LuaEnv();

            // luaEnv.DoString("require 'CSharpCallLua'");

            luaEnv.AddLoader(MyLoader);

            luaEnv.DoString("require 'CSharpCallLua'");


            //
            int age = luaEnv.Global.Get<int>("age");
            Debug.Log(age);

            // Person person = luaEnv.Global.Get<Person>("Person");
            // Debug.Log(person.name + person.age + person.home);

            //Interface 使用接口进行 进行 table 映射使用
            IPerson iPerson = luaEnv.Global.Get<IPerson>("Person");
            Debug.Log(iPerson.name + "-" + iPerson.age);

            iPerson.name = "Eligos2";
            luaEnv.DoString("print(Person.name)");
        }


        private byte[] MyLoader(ref string filePath)
        {
            Debug.Log(filePath);
            Debug.Log(Application.streamingAssetsPath);

            string absPath = Application.streamingAssetsPath + "/" + filePath + ".lua.txt";

            Debug.Log(absPath);

            return System.Text.Encoding.UTF8.GetBytes(File.ReadAllText(absPath));
        }

        // Update is called once per frame
        void Update()
        {

        }

        private void OnDestory()
        {
            luaEnv.Dispose();
        }
    }

    [CSharpCallLua]
    public interface IPerson
    {
        string name { get; set; }
        int age { get; set; }
        string home { get; set; }
    }

    public class Person
    {
        public string name;
        public int age;
        public string home;
    }
}