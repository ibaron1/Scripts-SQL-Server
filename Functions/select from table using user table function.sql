select t.*
from FileStage2
cross apply fn_split_to_array(_rawStr,',') t