using UnityEngine;
using XLua;

namespace HotFixScripts
{
    [Hotfix]
    public class HotfixLogic : MonoBehaviour
    {
        public AssetBundleLoaderManager assetBundleLoaderManager;

        [LuaCallCSharp]
        private void CreatePrize()
        {

        }

        [LuaCallCSharp]
        private void Attact()
        {

        }
    }
}