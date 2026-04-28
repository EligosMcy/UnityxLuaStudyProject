using System;
using UnityEngine;
using XLua;

namespace BaseLuaController
{
    public class LuaCallCSharpController : MonoBehaviour
    {
        private string _luaCallCSharpName = "LuaCallCSharp";

        private LuaEnv _luaEnv => xLuaLoaderManager.Instance.LuaEnv;

        private void Start()
        {
            _luaEnv.DoString($"require '{_luaCallCSharpName}'");
        }
    }
}