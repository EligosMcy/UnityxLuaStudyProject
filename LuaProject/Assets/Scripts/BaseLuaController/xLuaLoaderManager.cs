using System;
using System.IO;
using UnityEngine;
using UnityEngine.UIElements;
using XLua;

namespace BaseLuaController
{
    public class xLuaLoaderManager : MonoBehaviour
    {
        private xLuaLoaderManager()
        {

        }

        private LuaEnv _luaEnv;
        public LuaEnv LuaEnv => _luaEnv;

        private static xLuaLoaderManager _instance;

        public static xLuaLoaderManager Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = FindFirstObjectByType<xLuaLoaderManager>();

                    if (_instance == null)
                    {
                        GameObject obj = new GameObject("xLuaLoaderManager");
                        _instance = obj.AddComponent<xLuaLoaderManager>();
                        DontDestroyOnLoad(obj);
                    }
                }

                return _instance;
            }
        }

        private void Awake()
        {
            if (_instance != null && _instance != this)
            {
                Destroy(gameObject);
                return;
            }

            _instance = this;
            DontDestroyOnLoad(gameObject);

            _luaEnv = new LuaEnv();
            _luaEnv.AddLoader(myLoader);
        }


        // private void Start()
        // {
        //     string _luaTextStr = "HelloWorld.lua";
        //     TextAsset textAsset = Resources.Load<TextAsset>(_luaTextStr); //HelloWorld.lua.text;
        //
        //     //执行字符串
        //     _luaEnv.DoString(textAsset.text);
        //
        //     //按照Loader 执行Lua脚本
        //     _luaEnv.DoString("require 'HelloWorld'");
        // }


        private byte[] myLoader(ref string filePath)
        {
            string absPath = Application.streamingAssetsPath + "/" + filePath + ".lua.txt";

            return System.Text.Encoding.UTF8.GetBytes(File.ReadAllText(absPath));
        }

        private void OnDestroy()
        {
            _luaEnv.Dispose();
        }
    }
}