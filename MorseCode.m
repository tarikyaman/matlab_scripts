function MorseCode
%MORSECODE Morse Code Player
% Morse code can be sent in three ways:  
% Transmit Alphabet, 
% Transmit From File and 
% Transmit From Keyboard. 
% The code speed(rate of dots and dashes), word speed
% (period between words) and audio frequency of transmitted 
% dots and dashes can be adjusted.  The word speed is 
% restricted to be equal or less than the code speed.  The code 
% and word speed can be adjusted either by the sliders or by 
% entering values in the respective text fields.
%
% When transmitting either a text file or alphabet 
% there is a stop transmission button to allow the operator to 
% terminate the transmission.
% 
% When transmitting a file the user must first, using 
% the "Select TextFile" from the menu bar, select a file to be 
% transmitted.  The transmission will stop when the end of the 
% file is reached. All text in the file is converted to upper 
% case as it is being used.
%
% When the Transmit Keyboard is selected a small modal 
% window opens and retains focus until the transmission is 
% ended.  The transmission is ended by pressing the escape key. 
%  The inputted text is buffered and transmitted at the 
% selected rates.  When entering the text from the keyboard, 
% pressing the backspace key will delete the last character 
% entered from the input buffer.
%
% From the menu bar selecting "Code Table" will display the 
% code table built into the program.  There are 60 entries in 
% the table with the last being a word space.
%
% General Design of the Program
%
% The core of the program is the CodeTable.  The function BuildCodeTable 
% creates a 60x4 cell array where the first 3 columns are text and contain 
% the character, dots and dashes, dits and daws.  The fourth column is 
% reserved for a wave file that represents the Morse code for that character 
% at the selected speed.
%
% After the GUI is constricted, to initialize the program the function 
% FillCodeTable is called.  This function first calls BuildCodeTable to 
% populate the first three columns of the CodeTable.  Then this function 
% builds the dots dashes and spaces for the selected code and word speed 
% by calling the function MakeWave to build the wave file for a dot, dash 
% and spaces.  Then MakeCharacter is called to build the wave file for each 
% character.  This result is stored in the fourth column of the CodeTable 
% for each of the character entries in the table.
%
% When either the speed or frequency is changed, this process is repeated so 
% there is a new CodeTable constructed to use with the new settings.  The 
% process of transmission consist of taking each character of the input 
% stream and sending it to the standard audio output using waveplay.  
% Because waveplay does not return until the sample is sent, when sending 
% the alphabet or a loaded text string the functions XmitAlphabetCallback 
% and XmitFileCallback just loop through all of the characters until completed.
%
% Transmitting from the keyboard is a bit more complicated.  The 
% XmitKbdCallback starts a timer task and opens a small modal window 
% activating the KeyPressFunction which links to GetKeyCallback.  At 
% GetKeyCallback each keyboard entry is put into a 2xn cell array 
% InputString.  In row 1 is the character and in row 2 is the wave file 
% for that character.  This is continued until the operator presses escape.  
% Then the character string 'end' in placed in the character slot and the 
% keyboard entry process is terminated.
% 
% All the while this input is going on the timer task, TimerTaskCallback, 
% is looking at the InputString to see if there is a new character.  If 
% there is, it is transmitted, and the program does not return until the 
% transmission is complete.  Then the timer task continues and repeats this 
% process until it finds the string 'end' and then terminates.
 
%%   Set start up values
    
    IsFile = 0;                 %   This is set to 1 when a file to transmit is loaded
    StopXmit = 0;               %   Set to 1 when operator wants to stop the transmission
    TextToSend = [];            %   Text file built from text input file
    KbdHandle = 0;              %   Set to Kbd figure handle when Xmit from Kbd is started
    AlphabetInUse = 0;          %   Set to 1 when alphabet is being transmitted
    FileXmitInUse = 0;          %   Set to 1 when text file is being transmitted
    KbdXmitInUse = 0;           %   Set to 1 when keyboard input is being transmitted
    CharacterCount = 0;         %   Use this to count input characters
    SentCount = 0;              %   Use this to count output characters
    TimerHandle = 0;            %   Set to handle value when timer is started
    InputString = cell(2,1);    %   Set up and clear input array
    
%   Frequency list for the frequency drop down list    
    FrequencyList = {'Frequency' '300' '400' '500' '600' '700' ...
        '800' '900' '1000' '1200' '1400'};
   
%   Set default start up speed and min and max speed
    StartSpeed = 15;
    MaxSpeed = 25;
    MinSpeed = 5;
    CodeSpeed = StartSpeed;
    WordSpeed = StartSpeed/2;
    if WordSpeed < MinSpeed
        WordSpeed = MinSpeed;
    end
    
%%  Set figure and uicontrol variables    
%   Get user screen size
    SC = get(0, 'ScreenSize');
    MaxMonitorX = SC(3);
    MaxMonitorY = SC(4);

%   Set the figure window size values.  These are adjusted to account for
%   the users screen size.
    
    GUIScale = .7;                          %   Percent of screen filled by the GUI   
    MaxWindowX = GUIScale*MaxMonitorX;      %   Width of GUI      
    MaxWindowY = GUIScale*MaxMonitorY;      %   Height of GUI
    XBorder = (1-GUIScale)*MaxWindowX/2;    %   Offset from left
    YBorder = (1-GUIScale)*MaxWindowY/2;    %   Offset from bottom
    TextFont = round(MaxMonitorY/200)+6;
    TextHeight = 2.4*TextFont;
    HeaderFont = round(MaxMonitorY/200)+12;
    HeaderWidth = MaxWindowX/3;
    HeaderHeight = 2.4*HeaderFont;
    VerticalHeight = (MaxWindowY-3*HeaderHeight);
    VerticalSpace = VerticalHeight/15;
    HorzontalSpace = MaxWindowY/11;
    ActionPushbuttonWidth = MaxWindowX/5;
    
    
%   Set the color varables
    Green = [.255 .627 .225];     % Dark Green
    White = [1  1  1];            % White
    
%%  Build the main figure window with header

%   figure window
    handles.GUIFigHandle = figure(...
        'Units', 'pixels',...
        'Toolbar', 'none',...
        'Position',[ XBorder, YBorder, MaxWindowX, MaxWindowY ],...
        'NumberTitle', 'off',...
        'Name', 'Morse Code Practice System',...
        'MenuBar', 'none',...
        'Resize', 'off',...
        'DockControls', 'off',...
        'Color', White);
      
%   Set up Application title
    uicontrol('Style', 'text',...
        'Position', [ MaxWindowX/2-HeaderWidth/2 ...
                MaxWindowY-2*HeaderHeight ...
                HeaderWidth HeaderHeight ],...
        'string', 'Morse Code Practice System',...
        'BackgroundColor', White,...
        'HorizontalAlignment', 'center',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', HeaderFont ); 
            
%%  Create uicontrol for Code Speed value

%   Text label
    uicontrol('Style', 'text',...
        'Position', [ 2*HorzontalSpace ...
            VerticalHeight-1*VerticalSpace ...
            2*HorzontalSpace TextHeight ],...
        'string', 'Code Speed',...
        'BackgroundColor', White,...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont ); 

%   Edit text box
    handles.DisplayCodeSpeed = uicontrol('Style', 'edit',...
        'Position', [ 4*HorzontalSpace ...
            VerticalHeight-1*VerticalSpace ...
            HorzontalSpace TextHeight ] ,...
        'string', int2str(StartSpeed),...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont,...
        'callback',{@UpdateSpeedCallback, handles, 1 });

%   Slider control
    handles.SliderCodeSpeed = uicontrol('style','slider', ...
        'position',[6*HorzontalSpace ...
            VerticalHeight-1*VerticalSpace ...
            4*HorzontalSpace TextHeight], ...
        'value',(StartSpeed-MinSpeed)/(MaxSpeed-MinSpeed), ...
        'callback',{@UpdateSpeedCallback, handles, 2 });

%   Set the Hand varable so the handles will be visible when needed
    Hand.SliderCodeSpeed = handles.SliderCodeSpeed;
    Hand.DisplayCodeSpeed = handles.DisplayCodeSpeed;

%%  Create uicontrol for Word Speed value

%   Text label
    uicontrol('Style', 'text',...
        'Position', [ 2*HorzontalSpace ...
            VerticalHeight-3*VerticalSpace ...
            2*HorzontalSpace TextHeight ],...            
        'string', 'Word Speed',...
        'BackgroundColor', White,...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont ); 

%   Edit text box
    handles.DisplayWordSpeed = uicontrol('Style', 'edit',...
        'Position', [ 4*HorzontalSpace ...
            VerticalHeight-3*VerticalSpace ...
            HorzontalSpace TextHeight ],...
        'string', int2str(WordSpeed),...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont,...
        'callback',{@UpdateSpeedCallback, handles, 3 }); 

%   Slider control    
    handles.SliderWordSpeed = uicontrol('style','slider', ...
        'position',[ 6*HorzontalSpace ...
            VerticalHeight-3*VerticalSpace ...
            4*HorzontalSpace TextHeight], ...
        'value',(WordSpeed-MinSpeed)/(MaxSpeed-MinSpeed), ...
        'callback',{@UpdateSpeedCallback, handles, 4 });
    
%   Set the Hand varable so the handles will be visible when needed    
    Hand.SliderWordSpeed = handles.SliderWordSpeed;
    Hand.DisplayWordSpeed = handles.DisplayWordSpeed;

%%  Create uicontrol drop down to select frequency

    uicontrol('Style', 'text',...
        'Position', [ 12*HorzontalSpace ...
            VerticalHeight-1.5*VerticalSpace ...
            3*HorzontalSpace TextHeight ],...            
        'string', 'Select Frequency',...
        'BackgroundColor', White,...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont ); 
    

    handles.SelectFrequency = uicontrol('Style', 'popupmenu',...
        'Position', [ 12.5*HorzontalSpace ...
            VerticalHeight-2.5*VerticalSpace ...
            HorzontalSpace TextHeight ] ,...        
        'String', FrequencyList,...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont,...
        'Callback', {@SelectFrequencyCallback, handles }) ;
    
%%  Set up the Transmitted Character Displays    
%   Transmitted Character Display
    
    uicontrol('Style', 'text',...
        'Position', [ 1.8*HorzontalSpace ...
            VerticalHeight-6.5*VerticalSpace ...
            2.1*HorzontalSpace 3*TextHeight ],...            
        'string', 'Character being Transmitted',...
        'BackgroundColor', White,...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont ); 
    
    handles.XmitCharacter = uicontrol('Style', 'text',...
        'Position', [ 4*HorzontalSpace ...
            VerticalHeight-5.7*VerticalSpace ...
            HorzontalSpace 2*TextHeight ],...            
        'string', ' ',...
        'HorizontalAlignment', 'center',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'ForegroundColor', Green,...
        'FontSize', 2.5*TextFont ); 
    
%   Transmitted Character String Display
    
    uicontrol('Style', 'text',...
        'Position', [ 6*HorzontalSpace ...
            VerticalHeight-6.5*VerticalSpace ...
            2*HorzontalSpace 3*TextHeight ],...            
        'string', 'String Being Transmitted',...
        'BackgroundColor', White,...
        'HorizontalAlignment', 'center',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont ); 
    
        SentString = ' ';
    handles.XmitString = uicontrol('Style', 'text',...
        'Position', [ 8.2*HorzontalSpace ...
            VerticalHeight-5.7*VerticalSpace ...
            7*HorzontalSpace 2.3*TextHeight ],...            
        'string', SentString,...
        'HorizontalAlignment', 'left',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'ForegroundColor', Green,...
        'FontSize', TextFont ); 
    
%%  Set up the Action Pushbuttons

%   Transmit Alphabet pushbutton
    handles.XmitAlphabet = uicontrol('Style', 'pushbutton',...
        'Position', [ .5*ActionPushbuttonWidth ...
            VerticalHeight-8*VerticalSpace ...
            ActionPushbuttonWidth 2*TextHeight ] ,...
        'string', 'Transmit Alphabet',...
        'ForegroundColor', Green,...
        'HorizontalAlignment', 'center',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont,...
        'Callback', {@XmitAlphabetCallback, handles } );

%   Transmit File pushbutton
    handles.XmitFile = uicontrol('Style', 'pushbutton',...
        'Position', [ 2*ActionPushbuttonWidth ...
            VerticalHeight-8*VerticalSpace ...
            ActionPushbuttonWidth 2*TextHeight ] ,...
        'string', 'Transmit File',...
        'ForegroundColor', Green,...
        'HorizontalAlignment', 'center',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont,...
        'Callback', {@XmitFileCallback, handles } );
    
%   Transmit from Keyboard pushbutton
    handles.XmitKbd = uicontrol('Style', 'pushbutton',...
        'Position', [ 3.5*ActionPushbuttonWidth ...
            VerticalHeight-8*VerticalSpace ...
            ActionPushbuttonWidth 2*TextHeight ] ,...
        'string', 'Transmit Keyboard',...
        'ForegroundColor', Green,...
        'HorizontalAlignment', 'center',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont,...
        'Callback', {@XmitKbdCallback, handles } );
    
%   Stop pushbutton
    uicontrol('Style', 'pushbutton',...
        'Position', [ 2*ActionPushbuttonWidth ...
            VerticalHeight-11*VerticalSpace ...
            ActionPushbuttonWidth 2*TextHeight ] ,...
        'string', 'Stop Transmission',...
        'ForegroundColor', Green,...
        'HorizontalAlignment', 'center',...
        'FontName', 'arial',...
        'FontWeight', 'bold',...
        'FontSize', TextFont,...
        'Callback', {@StopXmitCallback, handles } );
       
%%  Build the drop down menu

%   No comment necessary
        uimenu('Label', '| Select Text File |',...
            'Callback', @GetTextFileCallback );
        uimenu('Label', '| Code Table |',...
            'Callback', {@DisplayCodeTableCallback, handles });
        uimenu('Label', '|  Help  |',...
            'Callback', {@HelpAndAboutCallback, handles, 1});
        uimenu('Label', '|  About  |',...
            'Callback', {@HelpAndAboutCallback, handles, 2});
    
%%  Initilize System

%   Set the default frequency
    InitialSelection = 3;
    set(handles.SelectFrequency, 'value', InitialSelection);
    Frequency = str2num(FrequencyList{InitialSelection});  %#ok<ST2NM>
        
%  Build the initial Code Table
    [CodeTable, SampleRate] = FillCodeTable;

%%  HelpAndAboutCallback
    function HelpAndAboutCallback( ~, ~, ~, val )
    %   Displays the help text and the about box
        switch val

            case 1      % Help
                
            %   This opens the help in a pdf viewer
                 % open('MorseCodePlayer.pdf');
                
            %   This opens help in the MatLab browser
                 open('MorseCodePlayer.htm');
                
            %   This opens help in the system browser
                 % path = cd;
                 % str = ['file:///' path '\MorseCodePlayer.htm']
                 % web(str,'-browser');

            case 2      % About
                AboutString = {'Program created by James Willmann',...
                               '           jbw@jwillmann.com',...
                               '          Version 0.6 - 9/27/2009',...
                               '              Using MatLab R2013b'};
                msgbox(AboutString);
        end
    end

%%  UpdateSpeedCallback
    function UpdateSpeedCallback( hObject, ~, handles, val  )
    %	This function handles the code speed and word speed callbacks for
    %	the sliders and the text entries.  The word speed is constraines to
    %	be =< code speed.  The values are displayed and the codeTable is
    %	rebuilt

    %   Get the handles so they are visible here
        handles.SliderWordSpeed = Hand.SliderWordSpeed;
        handles.DisplayWordSpeed = Hand.DisplayWordSpeed;
        handles.DisplayCodeSpeed = Hand.DisplayCodeSpeed;
        handles.SliderCodeSpeed = Hand.SliderCodeSpeed;
    
        switch val       
            case 1      % Code speed text entered
                CodeSpeed = str2double(get(hObject,'string'));
                CodeSpeed = round(10*CodeSpeed)/10;

                if CodeSpeed < MinSpeed
                    CodeSpeed = MinSpeed;
                end
                if CodeSpeed > MaxSpeed
                    CodeSpeed = MaxSpeed;                
                end

                set(handles.SliderCodeSpeed, 'value',...
                    (CodeSpeed - MinSpeed)/(MaxSpeed- MinSpeed));
                set(handles.DisplayCodeSpeed,'string', num2str(CodeSpeed));

                if WordSpeed > CodeSpeed
                    WordSpeed = CodeSpeed;
                    set(handles.SliderWordSpeed,'value',...
                        (CodeSpeed - MinSpeed)/(MaxSpeed- MinSpeed));
                    set(handles.DisplayWordSpeed,'string', num2str(CodeSpeed));
                end

            case 2      % Code speed slider changed
                CodeSpeed = get(hObject,'Value');
                CodeSpeed = (MaxSpeed - MinSpeed)*CodeSpeed + MinSpeed;
                CodeSpeed = round(10*CodeSpeed)/10;
                set(handles.DisplayCodeSpeed,'string', num2str(CodeSpeed));

                if WordSpeed > CodeSpeed
                    WordSpeed = CodeSpeed;
                    set(handles.SliderWordSpeed,'value',...
                        (CodeSpeed - MinSpeed)/(MaxSpeed- MinSpeed));
                    set(handles.DisplayWordSpeed,'string', num2str(CodeSpeed));
                end            

            case 3      % Word speed text entered  
                WordSpeed = str2double(get(hObject,'string'));
                WordSpeed = round(10*WordSpeed)/10;

                if WordSpeed < MinSpeed
                    WordSpeed = MinSpeed;
                end

                if WordSpeed > CodeSpeed
                    WordSpeed = CodeSpeed;
                end

                set(handles.SliderWordSpeed,'value',...
                    (WordSpeed - MinSpeed)/(MaxSpeed- MinSpeed));
                set(handles.DisplayWordSpeed,'string', num2str(WordSpeed));

            case 4      % Word speed slider changed
                WordSpeed = get(hObject,'Value');
                WordSpeed = (MaxSpeed - MinSpeed)*WordSpeed + MinSpeed;
                WordSpeed = round(10*WordSpeed)/10;

                if WordSpeed > CodeSpeed
                    WordSpeed = CodeSpeed;
                    set(handles.SliderWordSpeed,'value',...
                        (WordSpeed - MinSpeed)/(MaxSpeed- MinSpeed));
                end

                set(handles.DisplayWordSpeed,'string', num2str(WordSpeed));            
        end

        %  Update the CodeTable
        [CodeTable, SampleRate] = FillCodeTable;

    end

%%  SelectFrequencyCallback
    function SelectFrequencyCallback( hObject, ~, handles )
        %   Gets a new frequency input and rebuilds the CodeTable with
        %   these new values
        
        Selection = get(hObject,'Value');
        if Selection == 1
            Selection = 2;
            set(handles.SelectFrequency, 'value', 2);
        end

        Frequency = str2num(FrequencyList{Selection}); %#ok<ST2NM>

        %  Update the CodeTable

            [CodeTable, SampleRate] = FillCodeTable;

    end

%%  XmitAlphabetCallback
    function XmitAlphabetCallback( ~, ~, handles )
    %   Transmits the alphabet (all entries of the CodeTable)
    
        if FileXmitInUse == 1
            return
        end
        
        StopXmit = 0;
        AlphabetInUse = 1;
        
        %  Output the CodeTable a character at a time
        SentString = [];
         for count = 1:59

             if StopXmit == 1
                 AlphabetInUse = 0;
                 return
             end

             SentString = [SentString ' ' CodeTable{count,1}];   
             set(handles.XmitCharacter, 'string', CodeTable{count,1} );
             set(handles.XmitString, 'string', SentString );
             drawnow
             
             player = audioplayer(CodeTable{count,4}, SampleRate);
             playblocking(player);

         end
        AlphabetInUse = 0;
    end

%%  XmitFileCallback
    function XmitFileCallback( ~, ~, handles )
    %   Transmits the file selected by the operator.
    
    %   Make sure its ok to run
        if AlphabetInUse == 1
            return
        end
        
        if  IsFile == 0
            msgbox('You must select a text file first');
            return
        end
        
    %   Initilize
        StopXmit = 0;
        FileXmitInUse = 1;
        ArraySize = size(TextToSend,2);

    %  Output the text string
        SentString = [];
        for n = 1:ArraySize
            Character = TextToSend(n);
            for m=1:60
                if Character == CodeTable{m,1}
                    WaveFile = CodeTable{m,4};
                    break
                end
            end

            if StopXmit == 1
                FileXmitInUse = 0;
                return
            end

            StringMax = 150;
            StringSize = size(SentString,2);
            if StringSize > StringMax
                SentString = SentString(3:StringSize);
            end

            SentString = [SentString ' ' Character];   
            set(handles.XmitCharacter, 'string', char(Character) );
            set(handles.XmitString, 'string', SentString );
            drawnow
            
            player = audioplayer(WaveFile, SampleRate);
            playblocking(player);            

        end
        FileXmitInUse = 0;
    end

%%  XmitKbdCallback
    function XmitKbdCallback( ~, ~, handles ) 
    %	This function initilizes and clears several varables, starts a
    %	timer task ansopens a modak window activating the KeyPressFcn

    %   Dont allow if other modes are running
        if FileXmitInUse ==  1 || AlphabetInUse == 1
            return
        end
        
     %  Set up varables and clear display 
        KbdXmitInUse = 1;
        SentString = [];
        set(handles.XmitCharacter, 'string', ' ' );
        set(handles.XmitString, 'string', SentString );
        drawnow
        
        CharacterCount = 0;         % Use this to count input characters
        SentCount = 0;              % Use this to count output characters
        InputString = cell(2,1);    % Clear input array
        
    %   Start a timer task   
        TimerHandle = timer('TimerFcn',@TimerTaskCallback,...
            'ExecutionMode','fixedSpacing',...
            'Period', .2);
        
   %    Open a modal window to display message and retain focus     
        KbdHandle = figure('KeyPressFcn',{@GetKeyCallback, handles},...
            'WindowStyle', 'modal',...
            'Units', 'pixels',...
            'Toolbar', 'none',...
            'Position',[ XBorder+10, YBorder+10, .3*MaxWindowX, .2*MaxWindowY ],...
            'NumberTitle', 'off',...
            'Name', 'Keyboard Transmission Active ',...
            'MenuBar', 'none',...
            'Resize', 'off',...
            'DockControls', 'off',...
            'Color', White);
        
    %   Text for the modal window
        uicontrol('Style', 'text',...
            'Position', [ .05*MaxWindowX ...
                .01*MaxWindowY ...
                .2*MaxWindowX 5*TextHeight ],...            
            'string', 'Enter text to transmit with the keyboard. Press Escape to terminate Transmission',...
            'BackgroundColor', White,...
            'HorizontalAlignment', 'left',...
            'FontName', 'arial',...
            'FontWeight', 'bold',...
            'FontSize', TextFont ); 
    end

%%  StopXmitCallback
    function StopXmitCallback( ~, ~, ~ ) 
    %   StopXmitCallback stops the timer event and sets the StopXmit flag.
        
        StopXmit = 1;
        
        if KbdXmitInUse > 0
            stop(TimerHandle);
        end

    end

%%  GetTextFileCallback
    function GetTextFileCallback( ~, ~ )
    %GetTextFile - Function lets operator select an input text file, converts
    %it to upper case and removes excess spaces when there are more than one in
    %a row.

    %   Get the file from the operator
        StartDirectory = cd;
        [FileNameWithTag, FileDirectory] = uigetfile({'*.txt'},...
                'Select a Text file',StartDirectory);
        if FileNameWithTag == 0,
            %   If User canceles then display error message
                errordlg('You Must select a File');
            return
        end
        FilePath = [FileDirectory  FileNameWithTag];
        
    %   Load the file
        InputText = fileread(FilePath);
    %   Convert all text to upper
        UpperText = upper(InputText);
    %   Find the space characters in the file
        SpaceData = isspace(UpperText);
    %   Get the length of the file
        InputSize = size(UpperText,2);

        SpaceCount = 0;
        OutputCount = 0;
        for i=1:InputSize
            if SpaceData(1,i) == 0
                OutputCount = OutputCount+1;
                CurrentCharacter = UpperText(1,i);

                if abs(UpperText(1,i)) == 8217
                    CurrentCharacter = '''';
                end

                TextToSend(1,OutputCount) = CurrentCharacter; %#ok<*AGROW>
                SpaceCount = 0;
            else
                if SpaceCount == 0
                    OutputCount = OutputCount+1;
                    TextToSend(1,OutputCount) = ' ';
                    SpaceCount = SpaceCount+1;
                end
            end        
        end
    %   Let them know the file is loaded and ready to send
        IsFile = 1;
    end

%%  FillCodeTable
    function [CodeTable, SampleRate] = FillCodeTable
    %Creates the CodeTable and fills it with wave files based on the code and
    %word rate

    %   Get the initial CodeTable
        CodeTable = BuildCodeTable;

    %   Set parameters
            Time = 1/CodeSpeed;
            WordRate = WordSpeed/CodeSpeed;

    %   Make wave samples
        %   Dit File
            Amp = 1;
            [Dit, SampleRate] = MakeWave(Time, Amp, Frequency ); %#ok<*NASGU>
        %   Daw File
            Amp = 1;
            [Daw, SampleRate] = MakeWave(3*Time, Amp, Frequency );
        %   Space
            Amp = 0;
            [Space, SampleRate] = MakeWave(Time, Amp, Frequency );
        %   Character Space
            Amp = 0;
            [CharacterSpace, SampleRate] = MakeWave(3*Time/WordRate, Amp, Frequency );
        %   Word Space
            Amp = 0;
            [WordSpace, SampleRate] = MakeWave(6*Time/WordRate, Amp, Frequency );

     %  Add wave files to the CodeTable array
         for count = 1:59
             CharacterCode = CodeTable{count, 2};
             WaveFile = MakeCharacter( CharacterCode, Dit, Daw, Space, CharacterSpace );
             CodeTable{count,4} = WaveFile;
         end

     %  Add WordSpace at the end
         CodeTable{60,4} = WordSpace;
    end

%%  MakeWave
    function [WavReturn, SampleRate ] = MakeWave(Tim, Amp, Freq )
    %   Created a wave file specified by the input parameters.
        NumPerCycle = 200;
        Length = round(Tim*Freq*NumPerCycle);
        SampleRate = Freq*NumPerCycle;
        Sig = zeros(1,Length);
        Co = 2;
        Ro = Co*NumPerCycle;
        Mplier = 1;
        for n = 1:Length
            if n > Length-Ro
                Mplier = (Length-n)/(Length-Ro);
            end
            Sig(n) = Amp*Mplier*sin(2*pi*(n/NumPerCycle));
        end
        WavReturn = Sig ;
    end

%%  MakeCharacter
    function WaveFile = MakeCharacter( CharacterCode, Dit, Daw, Space, CharacterSpace)
    %MakeCharacter puts together the wave file of a complete Morse character

        Siz = size(CharacterCode,2);
    %   Initilize WaveFile
        WaveFile = Space;
    %   Make the WaveFile
        for count = 1:Siz
            Digit = CharacterCode(count);
            switch Digit
                case '.'
                    WaveFile = [WaveFile Dit Space]; %#ok<*AGROW>
                case '-'
                    WaveFile = [WaveFile Daw Space];
                otherwise
                    WaveFile = [WaveFile Space];
            end                
        end
    %   Put a character space at the end
        WaveFile = [WaveFile CharacterSpace];
    end

%%  BuildCodeTable
    function CodeTable = BuildCodeTable
    %   Function to build initial code table
    %   The columns are
    %   1   Character
    %   2   Dot's and dashes
    %   3   dit's and daw's
    %   4   Wave file of character - to be added outside this function

    CodeTable = cell(60,6);

    %   Letters
        CodeTable{1,1} = 'A';
            CodeTable{1,2} = '.-';
            CodeTable{1,3} = 'dit daw';
        CodeTable{2,1} = 'B';
            CodeTable{2,2} = '-...';
            CodeTable{2,3} = 'daw dit dit dit';
        CodeTable{3,1} = 'C';
            CodeTable{3,2} = '-.-.';
            CodeTable{3,3} = 'daw dit daw dit';
        CodeTable{4,1} = 'D';
            CodeTable{4,2} = '-..';
            CodeTable{4,3} = 'daw dit dit';
        CodeTable{5,1} = 'E';
            CodeTable{5,2} = '.';
            CodeTable{5,3} = 'dit';
        CodeTable{6,1} = 'F';
            CodeTable{6,2} = '..-.';
            CodeTable{6,3} = 'dit dit daw dit';
        CodeTable{7,1} = 'G';
            CodeTable{7,2} = '--.';
            CodeTable{7,3} = 'daw daw dit';
        CodeTable{8,1} = 'H';
            CodeTable{8,2} = '....';
            CodeTable{8,3} = 'dit dit dit dit';
        CodeTable{9,1} = 'I';
            CodeTable{9,2} = '..';
            CodeTable{9,3} = 'dit dit';
        CodeTable{10,1} = 'J';
            CodeTable{10,2} = '.---';
            CodeTable{10,3} = 'dit daw daw daw';
        CodeTable{11,1} = 'K';
            CodeTable{11,2} = '-.-';
            CodeTable{11,3} = 'daw dit daw';
        CodeTable{12,1} = 'L';
            CodeTable{12,2} = '.-..';
            CodeTable{12,3} = 'dit daw dit dit';
        CodeTable{13,1} = 'M';
            CodeTable{13,2} = '--';
            CodeTable{13,3} = 'daw daw';
        CodeTable{14,1} = 'N';
            CodeTable{14,2} = '-.';
            CodeTable{14,3} = 'daw dit';
        CodeTable{15,1} = 'O';
            CodeTable{15,2} = '---';
            CodeTable{15,3} = 'daw daw daw';
        CodeTable{16,1} = 'P';
            CodeTable{16,2} = '.--.';
            CodeTable{16,3} = 'dit daw daw dit';
        CodeTable{17,1} = 'Q';
            CodeTable{17,2} = '--.-';
            CodeTable{17,3} = 'daw daw dit daw';
        CodeTable{18,1} = 'R';
            CodeTable{18,2} = '.-.';
            CodeTable{18,3} = 'dit daw dit';
        CodeTable{19,1} = 'S';
            CodeTable{19,2} = '...';
            CodeTable{19,3} = 'dit dit dit';
        CodeTable{20,1} = 'T';
            CodeTable{20,2} = '-';
            CodeTable{20,3} = 'daw';
        CodeTable{21,1} = 'U';
            CodeTable{21,2} = '..-';
            CodeTable{21,3} = 'dit dit daw';
        CodeTable{22,1} = 'V';
            CodeTable{22,2} = '...-';
            CodeTable{22,3} = 'dit dit dit daw';
        CodeTable{23,1} = 'W';
            CodeTable{23,2} = '.--';
            CodeTable{23,3} = 'dit daw daw';
        CodeTable{24,1} = 'X';
            CodeTable{24,2} = '-..-';
            CodeTable{24,3} = 'daw dit dit daw';
        CodeTable{25,1} = 'Y';
            CodeTable{25,2} = '-.--';
            CodeTable{25,3} = 'daw dit daw daw';
        CodeTable{26,1} = 'Z';
            CodeTable{26,2} = '--..';
            CodeTable{26,3} = 'daw daw dit dit';

    %   Numbers
        CodeTable{27,1} = '1';
            CodeTable{27,2} = '.----';
            CodeTable{27,3} = 'dit daw daw daw daw';
        CodeTable{28,1} = '2';
            CodeTable{28,2} = '..---';
            CodeTable{28,3} = 'dit dit daw daw daw';
        CodeTable{29,1} = '3';
            CodeTable{29,2} = '...--';
            CodeTable{29,3} = 'dit dit dit daw daw';
        CodeTable{30,1} = '4';
            CodeTable{30,2} = '....-';
            CodeTable{30,3} = 'dit dit dit dit daw';
        CodeTable{31,1} = '5';
            CodeTable{31,2} = '.....';
            CodeTable{31,3} = 'dit dit dit dit dit';
        CodeTable{32,1} = '6';
            CodeTable{32,2} = '-....';
            CodeTable{32,3} = 'daw dit dit dit dit';
        CodeTable{33,1} = '7';
            CodeTable{33,2} = '--...';
            CodeTable{33,3} = 'daw daw dit dit dit';
        CodeTable{34,1} = '8';
            CodeTable{34,2} = '---..';
            CodeTable{34,3} = 'daw daw daw dit dit';
        CodeTable{35,1} = '9';
            CodeTable{35,2} = '----.';
            CodeTable{35,3} = 'daw daw daw daw dit';
        CodeTable{36,1} = '0';
            CodeTable{36,2} = '-----';
            CodeTable{36,3} = 'daw daw daw daw daw';

    %   Puncuation
        CodeTable{37,1} = ',';
            CodeTable{37,2} = '--..--';
            CodeTable{37,3} = 'daw daw dit dit daw daw';
        CodeTable{38,1} = '.';
            CodeTable{38,2} = '.-.-.-';
            CodeTable{38,3} = 'dit daw dit daw dit daw';
        CodeTable{39,1} = '?';
            CodeTable{39,2} = '..--..';
            CodeTable{39,3} = 'dit dit daw daw dit dit';
        CodeTable{40,1} = ';';
            CodeTable{40,2} = '-.-.-';
            CodeTable{40,3} = 'daw dit daw dit daw';
        CodeTable{41,1} = ':';
            CodeTable{41,2} = '---...';
            CodeTable{41,3} = 'daw daw daw dit dit dit';
        CodeTable{42,1} = '/';
            CodeTable{42,2} = '-..-.';
            CodeTable{42,3} = 'daw dit dit daw dit';
        CodeTable{43,1} = '=';
            CodeTable{43,2} = '-...-';
            CodeTable{43,3} = 'daw dit dit dit daw';
        CodeTable{44,1} = '''';
            CodeTable{44,2} = '.----.';
            CodeTable{44,3} = 'dit daw daw daw daw dit';
        CodeTable{45,1} = '(';
            CodeTable{45,2} = '-.--.';
            CodeTable{45,3} = 'daw dit daw daw dit';
        CodeTable{46,1} = ')';
            CodeTable{46,2} = '-.--.-';
            CodeTable{46,3} = 'daw dit daw daw dit daw';
        CodeTable{47,1} = '-';
            CodeTable{47,2} = '-....-';
            CodeTable{47,3} = 'daw dit dit dit dit daw';
        CodeTable{48,1} = '+';
            CodeTable{48,2} = '.-.-.';
            CodeTable{48,3} = 'dit daw dit daw dit';
        CodeTable{49,1} = '@';
            CodeTable{49,2} = '.--.-.';
            CodeTable{49,3} = 'dit daw daw dit daw dit';
        CodeTable{50,1} = '"';
            CodeTable{50,2} = '.-..-';
            CodeTable{50,3} = 'dit daw dit dit daw dit';
        CodeTable{51,1} = '!';
            CodeTable{51,2} = '-.-.--';
            CodeTable{51,3} = 'daw dit daw dit daw daw';
        CodeTable{52,1} = '$';
            CodeTable{52,2} = '...-..-';
            CodeTable{52,3} = 'dit dit dit daw dit dit daw';
        CodeTable{53,1} = '&';
            CodeTable{53,2} = '.-...';
            CodeTable{53,3} = 'dit daw dit dit dit';

    %   Special Alphabet Characters
        CodeTable{54,1} = 'Á';
            CodeTable{54,2} = '.--.-';
            CodeTable{54,3} = 'dit daw daw dit daw';
        CodeTable{55,1} = 'Ä';
            CodeTable{55,2} = '.-.-';
            CodeTable{55,3} = 'dit daw dit daw';
        CodeTable{56,1} = 'É';
            CodeTable{56,2} = '..-..';
            CodeTable{56,3} = 'dit dit daw dit dit';
        CodeTable{57,1} = 'Ñ';
            CodeTable{57,2} = '--.--';
            CodeTable{57,3} = 'daw daw dit daw daw';
        CodeTable{58,1} = 'Ö';
            CodeTable{58,2} = '---.';
            CodeTable{58,3} = 'daw daw daw dit';
        CodeTable{59,1} = 'Ü';
            CodeTable{59,2} = '..--';
            CodeTable{59,3} = 'dit dit daw daw';

        %   Word space
        CodeTable{60,1} = ' ';
            CodeTable{60,2} = '   ';
            CodeTable{60,3} = '   ';
    end

%%  DisplayCodeTableCallback
    function DisplayCodeTableCallback( ~, ~, handles )
    %   This function takes the CodeTable and displays it in a
    %   table on a new figure
 
    %   Create the new figure
        handles.TableFigHandle = figure(...
            'Units', 'pixels',...
            'Position',[ XBorder, YBorder, MaxWindowX/2, 2*MaxWindowY/3 ],...
            'NumberTitle', 'off',...
            'Toolbar', 'none',...
            'Name', 'Morse Code Table',...
            'MenuBar', 'none',...
            'Resize', 'off',...
            'DockControls', 'off',...
            'Color', White);

    %   Build the data cell array to display
        DisplayData = cell(60,3);
        for i = 1:60
            for j = 1:3
                DisplayData(i,j) = CodeTable(i,j);
                if j==1
                DisplayData{i,j} = ['      ' DisplayData{i,j}];
                end
                if j==2
                DisplayData{i,j} = ['         ' DisplayData{i,j}];
                end
                if j==3
                DisplayData{i,j} = ['   ' DisplayData{i,j}];
                end
            end
        end
        

    %   Build the table
        TextFont = round(3*MaxMonitorY/200)-2;
        Offset = 22;        
        ColumnNames = {'Character' 'Dots and Dashes' 'Dits and Daws'};
        Width = (MaxWindowX)/6-Offset/3-3;
        Share = Width/2;
        ColumnWidths = {Width-Share Width Width+Share};

        handles.DataArray = uitable('ColumnName', ColumnNames,...
            'ColumnWidth', ColumnWidths,...
            'RowName', [],...
            'Data', DisplayData,...
            'FontSize', TextFont,...
            'Position', [1 1 ...
                MaxWindowX/2 2*MaxWindowY/3]);
    
    end

%%  GetKeyCallback
    function GetKeyCallback( ~, evnt, ~ )
    %   This function gets each key event from the keyboard and builds it
    %   into a 2xn cell array InputString along with its respective Morse
    %   wave file.  This continues until an easape key event is detected at
    %   which time the process is terminated.
    
    %   Close and get out if escape is entered
        if strcmp(evnt.Key, 'escape')
            close(KbdHandle);
            KbdHandle = 0;
            InputString{1,CharacterCount+1} = 'end';
            return
        end
        
    %   Remove the last character if backspace is entered    
        if strcmp(evnt.Key, 'backspace')
            CharacterCount = CharacterCount-1;
            InputString = InputString(:,1:CharacterCount);
            return
        end
        
     %  Get the character, convert to upper and find it in the CodeTable   
        Character = upper(evnt.Character);
        Found = 0;

        for m=1:60
            if Character == CodeTable{m,1}
                CharacterCount = CharacterCount+1;
                InputString{1,CharacterCount} = Character;
                InputString{2,CharacterCount} = CodeTable{m,4};
                Found = 1;
                break
            end
        end
        
     %  If it wasnt found get out and wait for the next one   
        if Found == 0;
            return
        end
        
    %   Start the timer when the first valid character has been entered    
        if CharacterCount == 1
            start(TimerHandle);
        end
        
    end 

%%  TimerTaskCallback
    function TimerTaskCallback(~,~)
    %   This task is entered by the timer every .2 seconds to see if a new 
    %   character has been added to InputString. If so it is transmitted 
    %   and the SentCount is increased. 
        
        SizeIn = size(InputString,2);
        
        if SizeIn <= SentCount
            return
        end
        
        SentCount = SentCount+1;
        Character = InputString{1,SentCount};
        
        if strcmp(Character,'end')
            stop(TimerHandle);
            KbdXmitInUse = 0;
            return
        end
        
        WaveFile = InputString{2,SentCount};
        
        StringMax = 150;
        StringSize = size(SentString,2);
        if StringSize > StringMax
            SentString = SentString(3:StringSize);
        end

        SentString = [SentString ' ' Character];   
        set(handles.XmitCharacter, 'string', char(Character) );
        set(handles.XmitString, 'string', SentString );
        drawnow

        player = audioplayer(WaveFile, SampleRate);
        playblocking(player);            
                  
    end

end

