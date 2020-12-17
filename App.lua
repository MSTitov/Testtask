print("Programm not work")

local ui = require('UI')
local controll = require('KeyControll')
local matrix = require('TableControll')

local cristals = {'A', 'B', 'C', 'D', 'E', 'F'}
  _G['matched'] = {}        -- Массив для хранения координато точек которые совпадают в ряд
  _G['m'] = "Start game"    -- Сообщение
  _G['c'] = 0               -- Кол-во очков
  _G['t'] = 360             -- Оставшихся очков движения
  _G['combo'] = 0           -- Счётчик комбо
 
 --[[
    Инициализация. Выводится начальный экран и ожидается нажание ENTER для начала игры. 
    Матрица заполняется случайными значениями и выводится на экран
 --]]
function init()
  ui.startScreen()
  controll.waitEnter()  
  matrix.mix() 
  ui.printTable(matrix)
end
 
 --[[
    При каждом движении кристала уменьшает счтётчик движений на один. Автоматическое движение 
    кристаллов вниз после комбинации, считается за движение. Если количество движение равно 
    нулю, но кристалы продолжабт автоматически двигаться, то уменьшаются заработанные очки
 --]]
function tick()
  os.execute("timeout 1 > nul")  
  if _G['t'] <= 0 then
    _G['m'] = "Ticks is out"  
    _G['c'] = _G['c'] - 1
  else
    _G['t'] = _G['t'] - 1
  end  
end

--[[
    После совпавшей комбинации, перемещает вниз кристаллы, которые были выше    
--]]
function dump()
  _G['m'] = "Ok!"  
  local matched = _G['matched']
  table.sort(matched, function (a, b) return a.y < b.y end)

  for i =1, #matched do
    X, Y = matched[i].x, matched[i].y
    while true do
      tick()
      ui.printTable(matrix)
      if Y == 1 then
        matrix[Y][X] = cristals[math.random(#cristals)]
        break
      else
        temp = matrix[Y][X]
        matrix[Y][X] = matrix[Y-1][X]
        matrix[Y-1][X] = temp
        Y = Y - 1
      end      
    end
    ui.printTable(matrix)
  end    
  _G['matched'] = {}
end  

--[[
    Вызов инициализации, и соновной игровой цикл
--]]
init()
while true do  
  if _G['t'] <= 0 then break end  --Выход из цикла если закончились очки движения
  
  from, to, isExit = controll.readPoints()  --Выход из цикла, если была введена команда выхода
  if isExit then break end
  
  if to == nil then         --Если отсутствует to, то возможно не верное движение за границы матрицы
    if (from == nil) then   --Если отсутствует from и to, то не валидная строка с командой
      _G['m'] = "Invalid move command"          
    end 
    goto continue
  end
  
  matrix.move(from, to) --Перемещение кристаллов
  tick()                --Задержка времени, для наглядности
  ui.printTable(matrix) --Отрисовка матрицы с перемещёнными элементами
    
  isMatched = matrix.checkMatched(from, to) --Проверка на наличие комбинаций
  if isMatched then                         --Если комбинации имеются, то удаление совпаших кристало
    dump()                                  --Перемещение вниз кристаллов которые выше
    matrix.checkPossibleMatches(dump)       --Проверка возможных совпадение после комбинации
    matrix.checkPossibleMove()              --Проверка отсутвия возможных ходов
  else                   
    matrix.move(to, from)                   --Если комбинаций нет, то кристалы возврашаются на свои места.
    _G['m'] = "Move returned. No match"
    _G['combo'] = 0                         --Счётчик комбо обнуляется         
  end  
  ::continue::
  ui.printTable(matrix)
end
ui.exitMessage()