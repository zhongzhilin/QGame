
--------------------------------
-- @module ResourceManager
-- @extend Ref
-- @parent_module 

--------------------------------
-- @overload self, int         
-- @overload self, string         
-- @function [parent=#ResourceManager] timeEnd
-- @param self
-- @param #string key
-- @return float#float ret (return value: float)

--------------------------------
-- 
-- @function [parent=#ResourceManager] StopBackgroundMusic 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] PauseBackgroundMusic 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] PlayEffect 
-- @param self
-- @param #char soundFileName
-- @param #float vol
-- @return unsigned int#unsigned int ret (return value: unsigned int)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] PauseAllEffects 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] PlayBackgroundMusic 
-- @param self
-- @param #char soundFileName
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] EnableSound 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] showTimeLog 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] SetBackgroundMusicVolumn 
-- @param self
-- @param #float vol
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] init 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] StopEffect 
-- @param self
-- @param #unsigned int effectId
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] showCurTime 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] TestCPPCrash 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] DisableSound 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] preloadEffect 
-- @param self
-- @param #char soundFileName
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] ResumeBackgroundMusic 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] ResumeAllEffects 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] IsSoundEnable 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] StopAllEffects 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] UpdateSoundEnable 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] SetEffectVolumn 
-- @param self
-- @param #unsigned int soundId
-- @param #float vol
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
--------------------------------
-- @overload self, int         
-- @overload self, string         
-- @function [parent=#ResourceManager] timeBegin
-- @param self
-- @param #string key
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)

--------------------------------
-- 
-- @function [parent=#ResourceManager] getInstance 
-- @param self
-- @return ResourceManager#ResourceManager ret (return value: ResourceManager)
        
--------------------------------
-- 
-- @function [parent=#ResourceManager] ResourceManager 
-- @param self
-- @return ResourceManager#ResourceManager self (return value: ResourceManager)
        
return nil
