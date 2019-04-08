
-- 文件加载列表
-- 以 / 结尾的表示目录，其它为文件
-- 按先后顺序加载，需要先加载的写在前面

local _List = {
  'app_cfg',
  'define',
  'wdefine',
  'external/',
  'cocos/',
  'util/',
  'game/'
}

return _List