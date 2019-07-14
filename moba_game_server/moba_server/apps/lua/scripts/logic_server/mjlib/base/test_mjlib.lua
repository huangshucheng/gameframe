local utils = require "logic_server/mjlib/utils"
local mjlib = require "logic_server/mjlib/base/mjlib"
local hulib = require "logic_server/mjlib/base/hulib"

local function test_one()
    -- 6万 6万 6万 4筒 4筒 4筒 4条 4条 5条 5条 6条 6条 发 发
    local t = {
        0,0,3,   3,2,3,   0,0,0,
        0,0,0,   1,1,0,   1,0,0,
        0,0,0,   0,0,0,   0,0,0,
        0,0,0,0, 0,0,0}
    local t = {
        3,3,3,   3,2,0,   0,0,0,
        0,0,0,   0,0,0,   0,0,0,
        0,0,0,   0,0,0,   0,0,0,
        0,0,0,0, 0,0,0}
    if not hulib.get_hu_info(t) then
        print("hcc>>test huinfo failed")
    else
        print("hcc>>test huinfo success")
    end
end

local function test_hu_sub(t, num)
    for j=1,16 do
        if j<= 9 then
            t[j] = t[j] + 3
        else
            local index = j - 9
            t[index] = t[index] + 1
            t[index + 1] = t[index + 1] + 1
            t[index + 2] = t[index + 2] + 1
        end

        if num == 4 then
            local valid = true
            for i=1,34 do
                if t[i] > 4 then
                    valid = false
                    break
                end
            end

            if valid and not hulib.get_hu_info(t) then
                print("hcc>>test failed111111")
                utils.print_array(t)
            end
        else
            test_hu_sub(t, num + 1)
        end

        if j<= 9 then
            t[j] = t[j] - 3
        else
            local index = j - 9
            t[index] = t[index] - 1
            t[index + 1] = t[index + 1] - 1
            t[index + 2] = t[index + 2] - 1
        end
    end
end

local function test_hu()
    local t = {}
    for i=1,33 do
        table.insert(t,0)
    end

    table.insert(t,2)

    test_hu_sub(t, 0)
end

local function main()
    local start = os.time()
    test_one()
    -- test_hu()
    print("hcc>>test time cost: ",os.time() - start, " second")
end

main()
