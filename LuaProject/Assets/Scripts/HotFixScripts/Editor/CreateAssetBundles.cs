using UnityEditor;
using System.IO;

namespace HotFix
{
    public class CreateAssetBundles
    {
        [MenuItem("Assets/BuildAllAssetBundles")]
        public static void BuildAllAssetBundles()
        {
            string dir = "AssetBundles";

            if (Directory.Exists(dir) == false)
            {
                Directory.CreateDirectory(dir);
            }

            BuildPipeline.BuildAssetBundles(dir, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
        }
    }
}