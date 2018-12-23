local Mah = class("Mah")

--麻将花色
Mah.MJ_FLOWER = {
    MS_NONE = 0,                                                        -- 空
    MS_WAN  = 1,                                                        -- 万
    MS_TIAO = 2,                                                        -- 条
    MS_TONG = 3,                                                        -- 筒
    MS_FENG = 4,                                                        -- 风
    MS_JIAN = 5,                                                        -- 箭
    MS_HUA  = 6,                                                        -- 花
    MS_BACK = 7,                                                        -- 背（空白牌面、牌背、财神归入此类）
    MS_COUNT = 8                                                        -- 花色数量
}

local MAH_DIVIDED = 16

--麻将的牌值    
Mah.MahValue = {
    MV_NONE           = 0,                                                 -- 空麻将值
    MV_YI_WAN         = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+1),              -- 一万 17
    MV_ER_WAN         = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+2),              -- 二万 18
    MV_SAN_WAN        = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+3),              -- 三万 19
    MV_SI_WAN         = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+4),              -- 四万 20
    MV_WU_WAN         = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+5),              -- 五万 21
    MV_LIU_WAN        = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+6),              -- 六万 22
    MV_QI_WAN         = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+7),              -- 七万 23
    MV_BA_WAN         = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+8),              -- 八万 24
    MV_JIU_WAN        = (Mah.MJ_FLOWER.MS_WAN*MAH_DIVIDED+9),              -- 九万 25

    MV_YI_TIAO        = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+1),             -- 一条 33
    MV_ER_TIAO        = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+2),             -- 二条 34
    MV_SAN_TIAO       = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+3),             -- 三条 35
    MV_SI_TIAO        = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+4),             -- 四条 36
    MV_WU_TIAO        = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+5),             -- 五条 37
    MV_LIU_TIAO       = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+6),             -- 六条 38
    MV_QI_TIAO        = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+7),             -- 七条 39
    MV_BA_TIAO        = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+8),             -- 八条 40
    MV_JIU_TIAO       = (Mah.MJ_FLOWER.MS_TIAO*MAH_DIVIDED+9),             -- 九条 41

    MV_YI_TONG        = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+1),             -- 一筒 49
    MV_ER_TONG        = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+2),             -- 二筒 50
    MV_SAN_TONG       = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+3),             -- 三筒 51
    MV_SI_TONG        = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+4),             -- 四筒 52
    MV_WU_TONG        = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+5),             -- 五筒 53
    MV_LIU_TONG       = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+6),             -- 六筒 54
    MV_QI_TONG        = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+7),             -- 七筒 55
    MV_BA_TONG        = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+8),             -- 八筒 56
    MV_JIU_TONG       = (Mah.MJ_FLOWER.MS_TONG*MAH_DIVIDED+9),             -- 九筒 57

    MV_DONG_FENG      = (Mah.MJ_FLOWER.MS_FENG*MAH_DIVIDED+1),             -- 东风 65
    MV_NAN_FENG       = (Mah.MJ_FLOWER.MS_FENG*MAH_DIVIDED+2),             -- 南风 66
    MV_XI_FENG        = (Mah.MJ_FLOWER.MS_FENG*MAH_DIVIDED+3),             -- 西风 67
    MV_BEI_FENG       = (Mah.MJ_FLOWER.MS_FENG*MAH_DIVIDED+4),             -- 北风 68
    MV_HONG_ZHONG     = (Mah.MJ_FLOWER.MS_JIAN*MAH_DIVIDED+1),             -- 红中 69
    MV_FA_CAI         = (Mah.MJ_FLOWER.MS_JIAN*MAH_DIVIDED+2),             -- 发财 70
    MV_BAI_BAN        = (Mah.MJ_FLOWER.MS_JIAN*MAH_DIVIDED+3),             -- 白板 71
    
    MV_MEI_HUA        = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+1),              -- 梅花 81
    MV_LAN_HUA        = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+2),              -- 兰花 82
    MV_ZHU_HUA        = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+3),              -- 竹花 83
    MV_JV_HUA         = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+4),              -- 菊花 84
    MV_CHUN_HUA       = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+5),              -- 春花 85
    MV_XIA_HUA        = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+6),              -- 夏花 86
    MV_QIU_HUA        = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+7),              -- 秋花 87
    MV_DONG_HUA       = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+8),              -- 冬花 88
    MV_DA_BAI_BAN     = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+9),              -- 大白板 89
    MV_LAO_SHU        = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+10),             -- 老鼠 90
    MV_MAO            = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+11),             -- 猫 91
    MV_CAI_SHEN       = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+12),             -- 财神 92
    MV_JIN_YUAN_BAO   = (Mah.MJ_FLOWER.MS_HUA*MAH_DIVIDED+13),             -- 金元宝 93

    MV_FACE           = (Mah.MJ_FLOWER.MS_BACK*MAH_DIVIDED+1),             -- 空白牌面 113
    MV_BACK           = (Mah.MJ_FLOWER.MS_BACK*MAH_DIVIDED+2),             -- 牌背 114
    MV_JOKER          = (Mah.MJ_FLOWER.MS_BACK*MAH_DIVIDED+6),             -- 财神 118
}

Mah.Action = {
    NONE = 0,
    PASS = 1,
    CHOW = 2,
    PONG = 3,
    KONG = 4,
    HU   = 5,
    FLOWER = 6,
}


Mah.CombType = {
    NONE = 0,
    CHOW = 1,               --吃
    PONG = 2,               --碰
    EXPOSED_KONG    = 3,    --明杠
    CONCEALED_KONG  = 4,    --暗杠
    FILL_KONG       = 5,    --补杠
    DOUBLE          = 6,
}

Mah.HuType = 
{
    ET_NONE         = 0,
    ET_SELF         = 1,    -- 自摸
    ET_DISCARD      = 2,    -- 点炮   
    ET_ROBKONG,     = 3,    -- 抢杠
    ET_ROBFLOWER,   = 4,    -- 抢花
    ET_DRAWN,       = 5,    -- 荒牌
    ET_HU_WAIT      = 6,
}

return Mah
