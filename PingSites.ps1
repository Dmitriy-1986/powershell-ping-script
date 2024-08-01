# Список сайтов и их описания
# Создаем ассоциативный массив (словарь), где ключи - это URL сайтов, а значения - их описания
$sites = @{
    "google.com" = "Google Search Engine"
    "dovgaldima.pp.ua" = "Personal Website of Dovgaldima"
    "dovgaldima.com" = "Commercial Website of Dovgaldima"
}

# Цвета для вывода в консоли
# Определяем цветовые схемы для различных сообщений
$Green = [ConsoleColor]::Green
$White = [ConsoleColor]::White
$Yellow = [ConsoleColor]::Yellow
$Red = [ConsoleColor]::Red

# Путь к WAV-файлу
# Указываем полный путь к WAV-файлу, который будет воспроизводиться при обнаружении недоступного сайта
$AlertSound = "C:\Users\Dovgal Dima\Desktop\script\sirena.wav"

# Функция для воспроизведения звука
# Определяем функцию, которая будет воспроизводить звук из указанного файла
function Play-Sound {
    param (
        [string]$path # Путь к аудиофайлу
    )
    $player = New-Object System.Media.SoundPlayer # Создаем объект для воспроизведения звука
    $player.SoundLocation = $path # Указываем путь к файлу
    $player.Play() # Начинаем воспроизведение
    Start-Sleep -Seconds 2 # Ждем 2 секунды, чтобы звук воспроизвелся полностью
    $player.Stop() # Останавливаем воспроизведение
}

# Основной цикл
# Будет выполняться бесконечно
while ($true) {
    foreach ($site in $sites.Keys) {
        $description = $sites[$site] # Получаем описание для текущего сайта
        Write-Host "Pinging: $site ($description)" -ForegroundColor $White # Выводим сообщение о том, что идет пингование сайта

        # Пингование сайта
        # Проверяем, доступен ли сайт. Возвращает True, если доступен, иначе False.
        $pingResult = Test-Connection -ComputerName $site -Count 4 -Quiet

        if ($pingResult) {
            # Если сайт доступен
            Write-Host "$site is available" -ForegroundColor $Green # Выводим сообщение о доступности сайта в зеленом цвете
        } else {
            # Если сайт недоступен
            Write-Host "Warning: $site ($description) is unreachable" -ForegroundColor $Yellow # Выводим предупреждение о недоступности сайта в желтом цвете

            # Запускаем воспроизведение звука в фоновом режиме
            Start-Job -ScriptBlock {
                param ($soundPath) # Принимаем путь к звуковому файлу как параметр
                $player = New-Object System.Media.SoundPlayer # Создаем объект для воспроизведения звука
                $player.SoundLocation = $soundPath # Указываем путь к файлу
                $player.Play() # Начинаем воспроизведение
                Start-Sleep -Seconds 2 # Ждем 2 секунды, чтобы звук воспроизвелся полностью
                $player.Stop() # Останавливаем воспроизведение
            } -ArgumentList $AlertSound | Out-Null # Передаем путь к звуковому файлу и запускаем задачу в фоновом режиме

            Start-Sleep -Seconds 3 # Ждем 3 секунды перед следующей итерацией
        }
        Write-Host # Выводим пустую строку для разделения результатов
    }
    
    # Разделительная линия после проверки всех сайтов
    Write-Host -ForegroundColor $Red ("-" * 10) # Выводим линию из 10 дефисов красным цветом
    
    Start-Sleep -Seconds 10 # Ждем 10 секунд перед началом следующего цикла
}
