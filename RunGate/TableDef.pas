unit TableDef;

interface

uses
  Windows, Messages, SysUtils;

type
  TMagDelayList = array[0..127] of Integer;

var
  MAIGIC_DELAY_ARRAY: array[0..127] of BOOL = (True,
    True, True, True, True, True, True, False, True, True, True, True, False, //1~12
    True, True, True, True, True, True, True, True, True, True, True, True, //13~24
    False, False, False, True, True, True, True, True, True, True, False, True, //25~36
    True, True, True, False, False, False, False, True, True, True, True, True, //37~48
    True, True, True, True, True, True, False, False, True, True, False, False, //49~60
    False, False, False, False, False, False, True, True, True, True, True, True, //61~72
    True, True, True, True, True, True, True, True, True, True, True, True, //73~84
    True, True, True, True, True, True, True, True, True, True, True, True, //85~96
    True, True, True, //97~99
    True, True, True, True, True, True, True, True, True, True, True, True, //100..111
    True, True, False, False, True, True, False, False, False, //112~119
    False, False, False, False, False, False, False); //120~128

  MAIGIC_ATTACK_ARRAY: array[0..127] of BOOL = (
    False,
    True, //小火球
    False, //治愈术
    False, //基本剑术
    False, //精神力战法
    True, //大火球
    True, //施毒术
    False, False,
    True, //地狱火焰
    True, //疾电雷光
    True, //雷电术
    False, //12
    True, //灵魂道府
    False, False, False, False, False, False, False, False,
    True, //火墙
    True, //爆裂火焰
    True, //地狱雷光
    False, False, False, False, False, False, False,
    True, //圣言术
    True, //冰咆哮
    False, False,
    True, //火焰冰
    True, //狮子吼 - 群体雷电术
    True, //群体施毒术
    True, //彻地钉
    False, //40
    True, //狮子吼
    False,
    False,
    True, //寒冰掌
    True, //灭天火
    False,
    True, //火龙烈焰
    False, //37~48
    False, //净化术
    False, //无极真气
    True, //51
    True, //52
    True, //53
    True, //54
    False, //55
    False, //逐日剑法
    True, //噬血术
    True, //流星火雨
    False, //59
    False, //60
    False, //61
    False, //62
    False, //63
    False, //64
    False, //65
    False, //66
    False, //67
    False,
    False,
    False,
    True, //71擒龙手
    True, True, True, True, True, True, True, True, True, True, True, True,
    True, True, True, True, True, True, True, True, True, True, True, True, //84~95
    True, True, True, True, //96..99
    True, True, True, True, True, True, True, True, True, True, True, True, //100~111
    True, True, True, True, True, True, True, True, //112
    True, True, True, True, True, True, True, True); //120~128

  //魔法的延迟表
  MAIGIC_DELAY_TIME_LIST_DEF: TMagDelayList;
  MAIGIC_DELAY_TIME_LIST: TMagDelayList = (
    60000,
    {01} 1110 + 60, //小火球
    {02} 1110 + 40, //治疗术
    {03} 1110, //初级剑法
    {04} 1110, //精神战法
    {05} 1110 + 60, //大火球
    {06} 1110 + 40, //施毒术
    {07} 1110, //攻杀剑法
    {08} 1110 + 30, //抗拒火环
    {09} 1110 + 60, //地狱火
    {10} 1110 + 100, //疾光电影
    {11} 1110 + 100, //雷电术
    {12} 1110, //刺杀剑术
    {13} 1110 + 60, //灵魂火符
    {14} 1110 + 40, //幽灵盾
    {15} 1110 + 40, //神圣战甲术
    {16} 1110 + 50, //困魔咒
    {17} 1110 + 50, //召唤骷髅
    {18} 1110 + 50, //隐身术
    {19} 1110 + 50, //集体隐身术
    {20} 1110 + 60, //诱惑之光
    {21} 1110 + 50, //瞬息移动
    {22} 1110 + 120, //火墙
    {23} 1110 + 60, //爆裂火焰
    {24} 1110 + 60, //地狱雷光
    {25} 1110, //半月弯刀
    {26} 1110, //烈火剑法
    {27} 1110, //野蛮冲撞
    {28} 1110 + 40, //心灵启示
    {29} 1110 + 40, //群体治愈术
    {30} 1110 + 120, //召唤神兽
    {31} 1110, //魔法盾
    {32} 1320 - 90, //圣言术
    {33} 1260 - 90, //冰咆哮
    {34} 1240 - 90, //解毒术
    {35} 1260 - 90, //老狮子吼
    {36} 1260 - 90, //火焰冰
    {37} 1320 - 90, //群体雷电术
    {38} 1320 - 90, //群体施毒术
    {39} 1320 - 90, //彻地钉
    {40} 1110, //双龙斩
    {41} 1230 - 90, //狮子吼
    {42} 1110, //龙影剑法
    {43} 1110, //雷霆剑法
    {44} 1260 - 90, //寒冰掌
    {45} 1260 - 90, //灭天火
    {46} 1260 - 90, //召唤英雄
    {47} 1260 - 90, //火龙烈焰
    {48} 1230 - 90, //气功波
    {49} 1240 - 90, //净化术
    {50} 1230 - 90, //无极真气
    {51} 1240 - 90, //飓风破
    {52} 1240 - 90, //诅咒术
    {53} 1240 - 90, //血咒
    {54} 1260 - 90, //骷髅咒
    {55} 1260 - 90, //
    {56} 1110, //逐日剑法
    {57} 1260 - 90, //噬血术
    {58} 1320 - 90, //流星火雨
    {59} 1300, //
    {60} 200, //破魂斩
    {61} 200, //劈星斩
    {62} 200, //雷霆一击
    {63} 200, //噬魂沼泽
    {64} 200, //末日审判
    {65} 200, //火龙气焰
    {66} 1500 - 90, //英雄开天斩
    {67} 1800 - 90, //
    {68} 1110, //
    {69} 1110, //
    {70} 1700 - 90, //心灵召唤
    {71} 1800 - 90, //英雄擒龙手
    {72} 1110, //
    {73} 1110, //
    {74} 100, //英雄分身术
    {75} 100, //英雄护体神盾
    {76} 100, //
    {77} 100, //
    {78} 100, //
    {79} 100, //
    {80} 100, //
    {81} 100, //
    {82} 100, //
    {83} 100, //
    {84} 100, //
    {85} 100, //
    {86} 100, //
    {87} 100, //
    100, 100, 100, 100,
    100, 100, 100, 100, 100, 100, 100, 100,
    350, 350, 350, 350, 350, 350, 350, 350, 350, 350, 350, 350, //100~111
    1300, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 100, 100, 100, 100);

  MAIGIC_NAME_LIST: array[0..127] of string = (
    '',
    '火球术',
    '治愈术',
    '基本剑术',
    '精神力战法',
    '大火球',
    '施毒术',
    '攻杀剑术',
    '抗拒火环',
    '地狱火',
    '疾光电影',
    '雷电术',
    '刺杀剑术',
    '灵魂火符',
    '幽灵盾',
    '神圣战甲术',
    '困魔咒',
    '召唤骷髅',
    '隐身术',
    '集体隐身术',
    '诱惑之光',
    '瞬息移动',
    '火墙',
    '爆裂火焰',
    '地狱雷光',
    '半月弯刀',
    '烈火剑法',
    '野蛮冲撞',
    '心灵启示',
    '群体治疗术',
    '召唤神兽',
    '魔法盾',
    '圣言术',
    '冰咆哮',
    '解毒术',
    '老狮子吼',
    '火焰冰',
    '群体雷电术',
    '群体施毒术',
    '彻地钉',
    '双龙斩',
    '狮子吼',
    '龙影剑法',
    '雷霆剑法',
    '寒冰掌',
    '灭天火',
    '召唤英雄',
    '火龙烈焰',
    '气功波',
    '净化术',
    '无极真气',
    '飓风破',
    '诅咒术',
    '血咒',
    '骷髅咒',
    '',
    '逐日剑法',
    '噬血术',
    '流星火雨',
    '',
    '破魂斩',
    '劈星斩',
    '雷霆一击',
    '噬魂沼泽',
    '末日审判',
    '火龙气焰',
    '开天斩', //66
    '神秘解读', //67
    '唯我独尊', //68
    '',
    '英雄出击',
    '擒龙手', //71
    '',
    '',
    '',
    '护体神盾',
    '',
    '',
    '', //78
    '',
    '',
    '', //81
    '',
    '', //83
    '', //84
    '',
    '',
    '', //87
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '', //99
    '追心刺',
    '三绝杀',
    '断岳斩',
    '横扫千军',
    '凤舞祭',
    '惊雷爆',
    '冰天雪地',
    '双龙破',
    '虎啸诀',
    '八卦掌',
    '三焰咒',
    '万箭归宗',
    '旋转风火轮',
    '断空斩',
    '倚天辟地',
    '血魂一击(战)',
    '血魂一击(法)',
    '血魂一击(道)',
    '', '', '', '',
    '', '', '', '', '', '');

implementation

initialization
  MAIGIC_DELAY_TIME_LIST_DEF := MAIGIC_DELAY_TIME_LIST;

finalization

end.
