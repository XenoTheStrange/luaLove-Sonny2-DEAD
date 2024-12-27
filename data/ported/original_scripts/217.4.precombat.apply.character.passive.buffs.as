thtk = 1;
while(thtk < 7)
{
   //If thisChar is active
   if(_root["playerKrin" + thtk].active == true)
   {
      //If thisChar has buffs
      if(_root["playerKrin" + thtk].passiveBuffs.length > 0)
      {
         //for buff in thisChar.passiveBuffs
         for(krinb in _root["playerKrin" + thtk].passiveBuffs)
         {
            //applyBuff(thisChar, buff, 1, thisChar)
            _root.applyBuffKrin(_root["playerKrin" + thtk],_root["playerKrin" + thtk].passiveBuffs[krinb],1,_root["playerKrin" + thtk]);
         }
         _root.firstUpdate = true;
         _root.applyChangesKrin(_root["playerKrin" + thtk]); //Curious we have to call this to apply the changes. See what it does later, and it behaves differently if root.firstUpdate is true.
         _root.firstUpdate = false;
      }
   }
   thtk++;
}
