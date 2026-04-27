using System;
using UnityEngine;

namespace BaseLuaController
{
    public class LuaCallCSharpController : MonoBehaviour
    {
        private string _luaCallCSharpName = "LuaCallCSharp";

        private void Start()
        {
            XLuaLoaderManager.Instance.LuaEnv.DoString(_luaCallCSharpName);
        }
    }
}