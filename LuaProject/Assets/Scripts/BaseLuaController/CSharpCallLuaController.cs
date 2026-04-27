using System;
using UnityEngine;
using XLua;

namespace BaseLuaController
{
    public class CSharpCallLuaController : MonoBehaviour
    {
        private string _cSharpCallLuaName = "CSharpCallLua";

        private LuaEnv _luaEnv = xLuaLoaderManager.Instance.LuaEnv;

        private void Start()
        {
            //使用Require 加载Lua 脚本
            _luaEnv.DoString($"require '{_cSharpCallLuaName}'");

            //加载全局变量
            int age = _luaEnv.Global.Get<int>("age");
            Debug.Log($"Age: {age}");

            Person person = _luaEnv.Global.Get<Person>("Person");
            Debug.Log($"Name: {person.name} ,Age: {person.age} Home: {person.home}");

            //Interface 使用接口 加载 Table 映射使用
        }
    }
}