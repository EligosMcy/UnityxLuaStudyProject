using System;
using System.IO;
using UnityEngine;
using XLua;

namespace DefaultNamespace
{
    public class HotfixScript : MonoBehaviour
    {
        private LuaEnv _luaEnv;

        private void Start()
        {
            _luaEnv = new LuaEnv();
            _luaEnv.AddLoader(MyLoader);
            _luaEnv.DoString("require 'hotfixScriptLua'");
        }

        private byte[] MyLoader(ref string filePath)
        {
            Debug.Log(filePath);
            Debug.Log(Application.streamingAssetsPath);

            string absPath = Application.streamingAssetsPath + "/" + filePath + ".lua.txt";

            Debug.Log(absPath);

            return System.Text.Encoding.UTF8.GetBytes(File.ReadAllText(absPath));
        }

        private void OnDisable()
        {
            _luaEnv.DoString("require 'hotfixScriptDisposeLua'");
        }


        private void OnDestroy()
        {
            _luaEnv.Dispose();
        }
    }
}