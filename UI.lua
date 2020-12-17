local interface = {}
local TABLE_SIZE = 10

--[[
    Очистка консоли
--]]
local function clearScreen()
  os.execute("cls")
end

--[[
    Вывод матрицы и вспомогательной информации в консоль
--]]
function interface.printTable(matrix)
  clearScreen()
  
  print("               Match 3 in line") 
  print("")
  print("   0 1 2 3 4 5 6 7 8 9     Status: " .. _G['m'])
  print("   -------------------")
  for i=1,TABLE_SIZE do
    row = i-1 .. "| " .. table.concat(matrix[i], " ") .. " |" .. i-1
    if i == 1 then 
      row = row .. "  Score: " .. _G['c']
      if _G['combo'] > 3 then
        row = row .. "  Combo: X2"        
      elseif _G['combo'] > 0 then
        row = row .. "  Combo: +" .. _G['combo']        
      end
      
    elseif i == 2 then
      row = row .. "  Tick: " .. _G['t'] 
    end
    print(row)    
  end  
  print("   -------------------")
  print("   0 1 2 3 4 5 6 7 8 9")  
end

--[[
    Сообщение при выходе 
--]]
function interface.exitMessage()
  print("==========================")
  print("          Exit")
  print("==========================")
end

--[[
    Начальный экран
--]]
function interface.startScreen()
  clearScreen()
  
  print("               Match 3 in line") 
  print("             Press Enter to start")
end

return interface
