function Exp= initTriggers(Exp)

%======================
%SET TRIGGER PROPERTIES
%======================
% Create a device object
% dio = digitalio('nidaq',1);
% warning('off', 'daq:digitalio:adaptorobsolete');
% dio = digitalio('parallel','LPT1');
daqhwinfo('parallel');
Exp.Trigger.dio = digitalio('parallel');

% Add lines -- Add eight output lines from port 0 (line-configurable).
addline(Exp.Trigger.dio,0:7,'out','Trgs');
addline(Exp.Trigger.dio,8:9,'in', 'resp');

Exp.Trigger.outLines = 1:8; % lines to send output
Exp.Trigger.inLines = 9:10; % ines to receive input
Exp.Trigger.uddobj = daqgetfield(Exp.Trigger.dio,'uddobject'); % Misteriously this speeds up putvalue by a factor of hundreds!
% putvalue(uddobj,1,1); %~20us (undocumented use demo in @dioline\putvalue.m and @digitalio\putvalue.m - args are: uddobj, vals [, lineInds])
% getvalue(uddobj,1); 20us (undocumented use demo in @dioline\getvalue.m and @digitalio\getvalue.m - args are: uddobj [, lineInds])


