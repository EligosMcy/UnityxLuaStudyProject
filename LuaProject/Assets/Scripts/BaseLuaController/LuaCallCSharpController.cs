using System;
using UnityEngine;

namespace BaseLuaController
{
    public class LuaCallCSharpController : MonoBehaviour
    {
        private string _luaCallCSharpName = "LuaCallCSharp";

        private void Start()
        {
            xLuaLoaderManager.Instance.LuaEnv.DoString(_luaCallCSharpName);
        }
    }
}