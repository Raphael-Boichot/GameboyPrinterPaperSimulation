arduinoObj = serialport("COM4",115200)
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);
arduinoObj.UserData = struct("Data",[],"Count",1)

while true
data = readline(arduinoObj)
end
