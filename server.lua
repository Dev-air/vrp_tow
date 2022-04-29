local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_towcar")

MySQL.createCommand("vRP/set_towcar","UPDATE vrp_user_moneys SET towcar = @towcar WHERE user_id = @user_id")
MySQL.createCommand("vRP/get_user_identity","SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
MySQL.createCommand("vRP/get_userbyreg","SELECT user_id FROM vrp_user_identities WHERE registration = @registration")

function vRP.towdiscord(color, name, message, footer)
    local embed = {
        {
          ["color"] = color,
          ["title"] = "**".. name .."**",
          ["description"] = message,
          ["footer"] = {
          ["text"] = footer,
          },
        }
      }
    
    PerformHttpRequest('웹훅링크', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function vRP.tow2discord(color, name, message, footer)
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
            ["text"] = footer,
            },
        }
        }
    
    PerformHttpRequest('웹훅링크', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local function ch_settow(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil and user_id ~= "" then
        vRP.prompt({player,"고유번호를 입력해주세요","",function(player,target_id)
            local target_id = parseInt(target_id)
            local target_source = vRP.getUserSource({target_id})
            --local target_name = GetPlayerName(target_source)
            local my_id = vRP.getUserId({player})
            local my_name = GetPlayerName(player)
            if target_id ~= 0 then
                if target_id ~= nil and target_id ~= "" then
                    if vRP.getTowcar({target_id}) == 0 then
                        vRP.setTowcar({target_id,1})
                        vRPclient.notify(player,{"~g~차량을 성공적으로 압류했습니다!"})
                        TriggerClientEvent('chatMessage', -1, "^*^4스피드렉카 압류 알림 ^0| 고유번호 :^3"..target_id.."^0번 차량이 압류되었습니다! 담당 직원 : ^3"..my_name)
                        vRP.towdiscord("16711680", "OO서버 차량 압류로그", "[ 담당자 고유번호 : ".. user_id .."번 ]\n\n[ 담당자 닉네임 : ".. my_name .." ]\n\n[ 소유주 고유번호 : ".. target_id .."번 ]\n\n", os.date("처리 일시 : %Y년 %m월 %d일 %H시 %M분 %S초 | Made by : ! 에어#5285"))
                    else
                        vRPclient.notify(player,{"~r~해당 유저는 이미 차량이 압류되있습니다!"})
                    end
                else
                    vRPclient.notify(player,{"~r~정확한 고유번호를 기재 해주세요"})
                end
            else
                vRPclient.notify(player,{"~r~정확한 고유번호를 기재 해주세요."})
            end
        end})
    end
end

local function ch_settow2(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil and user_id ~= "" then
        vRP.prompt({player,"고유번호를 입력해주세요","",function(player,target_id)
            local target_id = parseInt(target_id)
            local target_source = vRP.getUserSource({target_id})
            --local target_name = GetPlayerName(target_source)
            local my_id = vRP.getUserId({player})
            local my_name = GetPlayerName(player)
            if target_id ~= 0 then
                if target_id ~= nil and target_id ~= "" then
                    MySQL.execute("vRP/set_towcar", {user_id = target_id, towcar = 1})
                    vRPclient.notify(player,{"~g~차량을 성공적으로 압류했습니다!"})
                    TriggerClientEvent('chatMessage', -1, "^*^4스피드렉카 압류 알림 ^0| 고유번호 :^3"..target_id.."^0번 차량이 압류되었습니다! 담당 직원 : ^3"..my_name)
                    vRP.towdiscord("16711680", "OO서버 차량 압류로그", "[ 담당자 고유번호 : ".. user_id .."번 ]\n\n[ 담당자 닉네임 : ".. my_name .." ]\n\n[ 소유주 고유번호 : ".. target_id .."번 ]\n\n", os.date("처리 일시 : %Y년 %m월 %d일 %H시 %M분 %S초 | Made by : ! 에어#5285"))
                else
                    vRPclient.notify(player,{"~r~정확한 고유번호를 기재 해주세요"})
                end
            else
                vRPclient.notify(player,{"~r~정확한 고유번호를 기재 해주세요."})
            end
        end})
    end
end

local function ch_removetow(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil and user_id ~= "" then
        vRP.prompt({player,"고유번호를 입력해주세요","",function(player,target_id)
            local target_id = parseInt(target_id)
            local target_source = vRP.getUserSource({target_id})
            --local target_name = GetPlayerName(target_source)
            local my_id = vRP.getUserId({player})
            local my_name = GetPlayerName(player)
            if target_id ~= nil and target_id ~= "" then
                if vRP.getTowcar({target_id}) == 1 then
                    vRP.setTowcar({target_id,0})
                    vRPclient.notify(player,{"~g~해당 유저의 차량 압류를 성공적으로 해제완료"})
                    TriggerClientEvent('chatMessage', -1, "^*^4스피드렉카 압류 알림 ^0| 고유번호 :^3"..target_id.."^0번님의 차량이 압류해제 되었습니다! 담당 직원 : ^3"..my_name)
                    vRP.tow2discord("16711680", "OO서버 차량 압류해제로그", "[ 담당자 고유번호 : ".. user_id .."번 ]\n\n[ 담당자 닉네임 : ".. my_name .." ]\n\n[ 소유주 고유번호 : ".. target_id .."번 ]\n\n", os.date("처리 일시 : %Y년 %m월 %d일 %H시 %M분 %S초 | Made by : ! 에어#5285"))
                else
                    vRPclient.notify(player,{"~r~해당 유저는 차량 압류가 안되어있어요"})
                end
            else
                vRPclient.notify(player,{"~r~정확한 고유번호를 기재 해주세요"})
            end
        end})
    end
end

local function ch_removetow2(player,choice)
    local user_id = vRP.getUserId({player})
    local my_id = vRP.getUserId({player})
    local my_name = GetPlayerName(player)
    local company_id = 7
    local amount = 100000000
    if user_id ~= nil and user_id ~= "" then
        if vRP.getTowcar({user_id}) == 1 then
            if vRP.tryFullPayment({user_id,amount}) then
                vRP.setTowcar({user_id,0})
                vRP.AddToCompany({company_id, amount})
                vRPclient.notify(player,{"~y~차량 압류해제가 완료되었습니다."})
                TriggerClientEvent('chatMessage', -1, "^*^4스피드렉카 압류 알림 ^0| 고유번호 :^3"..user_id.."^0번님의 차량이 압류해제 되었습니다!")
                vRP.tow2discord("16711680", "OO서버 차량 압류해제로그", "[ 고유번호 : ".. user_id .."번 ]\n\n[ 닉네임 : ".. my_name .." ]\n\n", os.date("처리 일시 : %Y년 %m월 %d일 %H시 %M분 %S초 | Made by : ! 에어#5285"))
            else
                vRPclient.notify(player,{"~r~돈이 부족합니다."})
            end
        else
            vRPclient.notify(player,{"~r~차량 압류상태가 아닙니다."})
        end
    end
end

local function ch_carcheck(player,choice)
    vRP.prompt({player,"차량번호를 입력해주세요","",function(player,registration)
        vRP.getUserByRegistration({registration, function(user_id)
            if user_id ~= nil then
                vRP.getUserIdentity({user_id, function(identity)
                vRPclient.notify(player,{"~g~번호판~w~ : ".. registration .."\n~b~고유번호~w~ : ".. user_id .."번"})
                end})
            else
                vRPclient.notify(player,{"~r~정확한 차량번호를 기재 해주세요"})
            end
        end})
    end})
end

vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
        choices["[🚧]렉카"] = {function(player,choice)
            vRP.buildMenu({"*렉카 관리", {player = player}, function(menu)
                menu.name = "*렉카 관리"
                menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
                menu.onclose = function(player) vRP.openMainMenu({player}) end
                if vRP.hasPermission({user_id, "carpermission.tow"}) then
                    menu["차량 압류하기"] = {ch_settow,""}
                    menu["미접속 차량 압류하기"] = {ch_settow2,""}
                    --menu["차량 압류해제"] = {ch_removetow,""}
                    menu["차량번호 조회"] = {ch_carcheck,""}
                end
                if vRP.hasPermission({user_id, "user.paycheck"}) then
                    menu["차량 압류해제"] = {ch_removetow2,""}
                end
                vRP.openMenu({player,menu})
            end})
        end, ""}
		add(choices)
	end
end})