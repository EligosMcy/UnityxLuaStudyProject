using System;
using System.IO;
using UnityEngine;
using XLua;
using static Tutorial.CSCallLua;
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

        //
        IPerson iPerson = luaEnv.Global.Get<IPerson>("Person"); //映射到interface实例，by ref，这个要求interface加到生成列表，否则会返回null，建议用法
        Debug.Log(iPerson.name + "-" + iPerson.age);

        // iPerson.name = "Eligos2";
        // luaEnv.DoString("print(Person.name)");
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
