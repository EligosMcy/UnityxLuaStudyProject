using System;
using UnityEngine;
using XLua;

namespace HotFixScripts
{
    /// <summary>
    /// 这个是当需要创建继承MonoBehaviour类的新类时,直接使用 Lua的进行使用是非常麻烦的
    /// 调用一些 Start,Update,OnTrigger,不是静态的调用很麻烦
    /// 这时候我们可以创建一个这样的空类(HotFixEmpty),当需要使用的时候,直接修改这个类来实现具体的功能更改和添加
    /// </summary>
    [Hotfix]
    public class HotFixEmpty : MonoBehaviour
    {
        private void Start()
        {
            
        }

        private void Update()
        {
            
        }

        private void OnTriggerEnter(Collider other)
        {
            
        }


        /// <summary>
        /// 用来在Lua中修改的空方法
        /// </summary>
        //当一个方法使用过了以后,可以使用其他方法并进行修改实现添加新功能
        private void behaviourMethod01()
        {

        }

        private void behaviourMethod02()
        {

        }
    }
}