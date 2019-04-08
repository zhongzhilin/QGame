
--------------------------------
-- @module LogMore
-- @parent_module 

--------------------------------
-- 
-- @function [parent=#LogMore] isInShowLog 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#LogMore] logError 
-- @param self
-- @param #char pszContent
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] writeFileData 
-- @param self
-- @param #char filePaths
-- @param #char strSign
-- @param #char pszContent
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#LogMore] setOpenPrintLogModuleList 
-- @param self
-- @param #array_table moduleList
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] pvpStart 
-- @param self
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] setLogLevel 
-- @param self
-- @param #int lv
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] printLogInfo 
-- @param self
-- @param #string logTypeName
-- @param #char pszContent
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] writeToFile 
-- @param self
-- @param #char pszContent
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#LogMore] writeAllRecordToFile 
-- @param self
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] showErrorWindow 
-- @param self
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] init 
-- @param self
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] setNeedPrintLogModuleList 
-- @param self
-- @param #array_table moduleList
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] writeRecordToFile 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#LogMore] setIsPvp 
-- @param self
-- @param #bool ispvp
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] insertOpenLogModule 
-- @param self
-- @param #string logModuleName
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] pvpStop 
-- @param self
-- @return LogMore#LogMore self (return value: LogMore)
        
--------------------------------
-- 
-- @function [parent=#LogMore] insertNeeLogModule 
-- @param self
-- @param #string logModuleName
-- @return LogMore#LogMore self (return value: LogMore)
        
return nil
