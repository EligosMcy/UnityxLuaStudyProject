using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor.Rendering;
using UnityEngine;
using UnityEngine.Networking;
using XLua;

namespace HotFixScripts
{
    public class AssetBundleLoaderManager : MonoBehaviour
    {
        public static Dictionary<string, GameObject> PrefabDictionary = new Dictionary<string, GameObject>();

        private void Start()
        {
            StartCoroutine(nameof(LoadResourceCorotine));
        }

        [LuaCallCSharp]
        public static void LoadAssetBundle(string resName, string filePath)
        {
            AssetBundle ab = AssetBundle.LoadFromFile(@"D:\Project\UnityxLuaStudyProject\LuaProject\AssetBundles\" + filePath);
            GameObject gameObject = ab.LoadAsset<GameObject>(resName);

            PrefabDictionary.Add(resName, gameObject);
        }


        [LuaCallCSharp]
        public static GameObject GetGameObject(string goName)
        {
            return PrefabDictionary[goName];
        }

        //使用UnityWebRequest,进行资源加载

        public void WebLoadAssetBundle(string resName, string filePath)
        {
            StartCoroutine(LoadResourceCorotine(resName, filePath));
        }

        IEnumerator LoadResourceCorotine(string resName, string filePath)
        {
            UnityWebRequest unityWebRequest = UnityWebRequestAssetBundle.GetAssetBundle(@"http://localhost/AssetBundles" + filePath);
            yield return unityWebRequest.SendWebRequest();
            AssetBundle ab = (unityWebRequest.downloadHandler as DownloadHandlerAssetBundle)?.assetBundle;
            GameObject gameObject = ab.LoadAsset<GameObject>(resName);
            PrefabDictionary.Add(resName, gameObject);
            yield return 0;
        }

        private IEnumerator LoadResourceCorotine()
        {
            //加载lua文件然后写入到正确的位置,实现具体的lua脚本更新
            UnityWebRequest request = UnityWebRequest.Get(@"http//localhost/hotFixScriptLua.lua.txt");
            yield return request.SendWebRequest();
            string str = request.downloadHandler.text;
            File.WriteAllText(@"D:\Project\UnityxLuaStudyProject\LuaProject\Assets\StreamingAssets\fish.lua.txt", str);


            //
            UnityWebRequest request1 = UnityWebRequest.Get(@"http//localhost/hotFixScriptDisposeLua.lua.txt");
            yield return request1.SendWebRequest();
            string str1 = request1.downloadHandler.text;
            File.WriteAllText(@"D:\Project\UnityxLuaStudyProject\LuaProject\Assets\StreamingAssets\hotFixScriptDisposeLua.lua.txt", str1);
        }
    }
}