classdef beamplot1Dv3 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure                   % 1D Hydro...
        OpenBPButton          matlab.ui.control.Button           % Open Files
        HPmodel               matlab.ui.container.ButtonGroup    % Hydropho...
        HPmodel0200           matlab.ui.control.RadioButton      % HNP-0200
        HPmodel0400           matlab.ui.control.RadioButton      % HNP-0400
        HPmodel0500           matlab.ui.control.RadioButton      % HNR-0500
        DCBgain               matlab.ui.container.ButtonGroup    % DC Block...
        gainvalhigh           matlab.ui.control.RadioButton      % High
        gainvallow            matlab.ui.control.RadioButton      % Low
        gainvalnone           matlab.ui.control.RadioButton      % None
        LabelNumericEditField matlab.ui.control.Label            % Frequenc...
        freq_in_mhz_input     matlab.ui.control.NumericEditField % [0 50]
        Label                 matlab.ui.control.Label            % X-axis o...
        Xoffsetvar            matlab.ui.control.NumericEditField % [-500 500]
        Label2                matlab.ui.control.Label            % Y-axis o...
        Yoffsetvar            matlab.ui.control.NumericEditField % [-500 500]
        IntensitiesCheckBox   matlab.ui.control.CheckBox         % Intensit...
        GainCheckBox          matlab.ui.control.CheckBox         % Gain Plot
        PNGCheckBox           matlab.ui.control.CheckBox         % Save .PNGs
        TIFFCheckBox          matlab.ui.control.CheckBox         % Save .TIFFs
        GeneratePlotButton    matlab.ui.control.Button           % Generate...
        Readme                matlab.ui.control.Button           % Readme
        LabelEditField        matlab.ui.control.Label            % Edit Fil...
        GraphTitleField       matlab.ui.control.EditField       
        Filepathfield         matlab.ui.control.EditField       
        MaxValuesCheckBox     matlab.ui.control.CheckBox         % Display ...
        NormplotCheckBox      matlab.ui.control.CheckBox         % Normaliz...
        Label8                matlab.ui.control.Label            % Power (W)
        powerfield            matlab.ui.control.NumericEditField % [0 50]
        Label9                matlab.ui.control.Label            % Efficien...
        efffield              matlab.ui.control.NumericEditField % [0 100]
        Label10               matlab.ui.control.Label            % Tube hei...
        heightfield           matlab.ui.control.NumericEditField % [0 50]
        Label11               matlab.ui.control.Label            % Tube rad...
        radiusfield           matlab.ui.control.NumericEditField % [0 50]
    end

    
    methods (Access = private)
        
        function dotheplot = makeonedplot(app,processed_data_cell);
            
            %processed_data_cell{index2} = [Xvalues;intensities;pressures;gains;normalized];
            warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')
            
            %re-ordering colors
            colors = [
                0    0.5000         0; %green
                1.0000         0         0; %red
                0         0    1.0000; %blue
                0.6350    0.0780    0.1840;%brown
                0.3010    0.7450    0.9330;% cyan
                0.4660    0.6740    0.1880; %lime green
                0.4940    0.1840    0.5560; %purple
                0.9290    0.6940    0.1250; %gold
                0.8500    0.3250    0.0980; %orange
                0    0.4470    0.7410; %light blue
                0.2500    0.2500    0.2500; %black
                .750    0     0.5;
                .8     .15     .87;
                .1  .5  .5
                ];
            
            %intensity plot
            if app.IntensitiesCheckBox.Value;
                opt_title1 = strcat('Central Intensity — ', app.GraphTitleField.Value)
                
                figure();
                hold on;
                for i = 1:length(processed_data_cell)
                    plot(processed_data_cell{i}(1,:),processed_data_cell{i}(2,:),'color',colors(i,:),'LineWidth', 1.5);
                end
                
                hTitle1 = title(opt_title1);
                hXLabel1 = xlabel('Depth (mm)');
                hYLabel1 = ylabel('Intensity (W/cm^2)');
                
                grid on;
                grid minor
                set( gca                       , ...
                    'FontName'   , 'Times New Roman' ,...
                    'FontSize', 18);
                
                set([hTitle1, hXLabel1, hYLabel1], ...
                    'FontName'   , 'Times New Roman');
                set([hXLabel1, hYLabel1]  , ...
                    'FontSize'   , 18          );
                set( [hTitle1]                    , ...
                    'FontSize'   , 18          , ...
                    'FontWeight' , 'bold'      );
                
                set(gca, ...
                    'Box'         , 'off'     , ...
                    'TickDir'     , 'out'     , ...
                    'TickLength'  , [.02 .02] , ...
                    'XMinorTick'  , 'on'      , ...
                    'YMinorTick'  , 'on'      , ...
                    'XColor'      , [.3 .3 .3], ...
                    'YColor'      , [.3 .3 .3], ...
                    'LineWidth'   , 1         );
                
                set(gcf,'PaperPositionMode','auto')
                BP_file_path = getappdata(app.UIFigure,'pathname');
                if app.TIFFCheckBox.Value;
                    figure_title_tiff = strcat(opt_title1,'.tif');
                    saveas(gca,fullfile(BP_file_path,figure_title_tiff),'tiff');
                end
                if app.PNGCheckBox.Value;
                    figure_title_png = strcat(opt_title1,'.png');
                    saveas(gca,fullfile(BP_file_path,figure_title_png),'png');
                end
                hold off;
            end
            
            
            %Print gain
            if app.GainCheckBox.Value;
                opt_title2 = strcat('Central Axial Gain — ', app.GraphTitleField.Value);
                
                figure();
                hold on;
                for i = 1:length(processed_data_cell)
                    plot(processed_data_cell{i}(1,:),processed_data_cell{i}(4,:),'color',colors(i,:),'LineWidth', 1.5);
                end
                
                hTitle1 = title(opt_title2);
                hXLabel1 = xlabel('Depth (mm)');
                hYLabel1 = ylabel('Intensity Gain');
                %     xlim([0 60])
                grid on;
                grid minor
                set( gca                       , ...
                    'FontName'   , 'Times New Roman' ,...
                    'FontSize', 18);
                
                set([hTitle1, hXLabel1, hYLabel1], ...
                    'FontName'   , 'Times New Roman');
                set([hXLabel1, hYLabel1]  , ...
                    'FontSize'   , 18          );
                set( [hTitle1]                    , ...
                    'FontSize'   , 18          , ...
                    'FontWeight' , 'bold'      );
                
                set(gca, ...
                    'Box'         , 'off'     , ...
                    'TickDir'     , 'out'     , ...
                    'TickLength'  , [.02 .02] , ...
                    'XMinorTick'  , 'on'      , ...
                    'YMinorTick'  , 'on'      , ...
                    'XColor'      , [.3 .3 .3], ...
                    'YColor'      , [.3 .3 .3], ...
                    'LineWidth'   , 1         );
                
                set(gcf,'PaperPositionMode','auto')
                BP_file_path = getappdata(app.UIFigure,'pathname');
                if app.TIFFCheckBox.Value;
                    figure_title_tiff = strcat(opt_title2,'.tif');
                    saveas(gca,fullfile(BP_file_path,figure_title_tiff),'tiff');
                end
                if app.PNGCheckBox.Value;
                    figure_title_png = strcat(opt_title2,'.png');
                    saveas(gca,fullfile(BP_file_path,figure_title_png),'png');
                end
                hold off;
            end
        end
    end

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % GeneratePlotButton button pushed function
        function GeneratePlotButtonButtonPushed(app)
            
            yoffset = app.Yoffsetvar.Value;
            xoffset = app.Xoffsetvar.Value;
            graphtitle = app.GraphTitleField.Value;
            freq_in_mhz = app.freq_in_mhz_input.Value;
            
            %Loads SenslookupHNP0400.txt, SenslookupHNP0200.txt, or
            %SenslookupHNR0500.txt. The text file is 5 tab-delineated columns of
            %values: FREQ_MHZ, SENS_DB, SENS_VPERPA, SENS_V2CM2PERW, and CAP_PF.
            if app.HPmodel0500.Value;
                hpvals = dlmread('SenslookupHNR0500.txt','',1,0);
                hydrophone_model = 'HNR-0500';
            elseif app.HPmodel0400.Value;
                hpvals = dlmread('SenslookupHNP0400.txt','',1,0);
                hydrophone_model = 'HNP-0400';
            elseif app.HPmodel0200.Value;
                hpvals = dlmread('SenslookupHNP0200.txt','',1,0);
                hydrophone_model = 'HNP-0200';
            end
            
            %Ensure query frequency falls within bounds of hydrophone calibration data,
            %if not, set to closest limit frequency.
            if freq_in_mhz < min(hpvals(:,1))
                freq_in_mhz_h = min(hpvals(:,1));
                fprintf(' WARNING: frequency below minimum hydrophone calibration. Using %2.2f MHz.\n', freq_in_mhz_h)
            elseif freq_in_mhz > max(hpvals(:,1))
                freq_in_mhz_h = max(hpvals(:,1));
                fprintf(' WARNING: frequency above maximum hydrophone calibration. Using %2.2f MHz.\n', freq_in_mhz_h)
            else
                freq_in_mhz_h = freq_in_mhz;
            end
            
            %Uses AH2020_senslookup.txt to look up values at freq using interpolation
            %for the DC block and preamp. The text file is 7 tab-delineated columns of
            %values: FREQ_MHZ, GAIN_DBHIGH,	PHASE_DEGHIGH, CAP_PREAMPHIGH, GAIN_DBLOW
            %PHASE_DEGLOW, and CAP_PREAMPLOW.
            pavals = dlmread('SenslookupAH2020.txt','',1,0);
            
            %Ensure query frequency falls within bounds of preamp calibration data,
            %if not, set to closest limit frequency.
            if freq_in_mhz < min(pavals(:,1))
                freq_in_mhz_p = min(pavals(:,1));
                fprintf(' WARNING: frequency below minimum preamp calibration. Using %2.2f MHz.\n', freq_in_mhz_p)
            elseif freq_in_mhz > max(pavals(:,1))
                freq_in_mhz_p = max(pavals(:,1));
                fprintf(' WARNING: frequency above maximum preamp calibration. Using %2.2f MHz.\n', freq_in_mhz_p)
            else
                freq_in_mhz_p = freq_in_mhz;
            end
            
            %Pull CAP_PF and SENS_VPERPA at the frequency specified.
            caphydro = interp1(hpvals(:,1),hpvals(:,5),freq_in_mhz_h,'linear');
            mc = interp1(hpvals(:,1),hpvals(:,3),freq_in_mhz_h,'linear');
            zacoustic=1.5e10; %impedance of water - includes unit correction for cm
            
            %Pull CAP_PREAMP and GAIN_DB for either high, low, or no gain.
            if app.gainvallow.Value;
                gaintext = ['Low'];
                capamp = interp1(pavals(:,1),pavals(:,7),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,5),freq_in_mhz_p,'linear');
                gain=10.^(gaindB./20); %converting dB to amplitude
                ml=mc.*gain.*caphydro./(caphydro+capamp);
                kcalfactor=zacoustic.*(ml).^2;
            elseif app.gainvalhigh.Value;
                gaintext = ['High'];
                capamp = interp1(pavals(:,1),pavals(:,4),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,2),freq_in_mhz_p,'linear');
                gain=10.^(gaindB./20); %converting dB to amplitude
                ml=mc.*gain.*caphydro./(caphydro+capamp);
                kcalfactor=zacoustic.*(ml).^2;
            elseif app.gainvalnone.Value;
                gaintext = ['No'];
                capamp = interp1(pavals(:,1),pavals(:,4),freq_in_mhz_p,'linear');
                gaindB = interp1(pavals(:,1),pavals(:,2),freq_in_mhz_p,'linear');
                kcalfactor = zacoustic.*(mc).^2;
                ml = mc;
            end
            
            relevant_data_cell = getappdata(app.UIFigure,'raw_data_cell');
            
            
            area = 2*pi*app.radiusfield.Value*app.heightfield.Value;
            Int_surface = app.powerfield.Value/area*app.efffield.Value;
            
            
            for index2 = 1:length(relevant_data_cell);
                rawtemp1 = relevant_data_cell{index2};
                Xvalues = rawtemp1(1,:);
                vpp2s = rawtemp1(2,:);
                
                intensities = vpp2s./(8*kcalfactor)   ;        %convert each Vpp² to I
                maxintensity = max(max((intensities)));         %find maximum value
                %avgintensity = mean(mean(intensities));         %find average intensity
                %total_power = avgintensity*axis1_temp(end)*axis2_temp(end)/100;
                pressures = sqrt(intensities*10000*2*1500*1000)/(1e6);  %convert I to MPa
                maxpressure = max(max((pressures)));         %find maximum value
                normalized =  intensities./maxintensity;        %make normalized table
                gains = intensities./Int_surface;
                
                processed_data_cell{index2} = [Xvalues;intensities;pressures;gains;normalized];
                %plot(Xvalues,intensities,'color',colors(index2,:),'LineWidth', 1.5);
            end
            
            makeonedplot(app,processed_data_cell);
            
            
            
            %             %Generate plots
            %             axis1 = axis1_temp+yoffset;
            %             axis2 = axis2_temp+xoffset;
            %             maxval_Ycoord = axis1(end)-(1/25)*axis1_temp(end);
            %             maxval_Xcoord = axis2(1)+(1/30)*axis2_temp(end);
            
            
            
            
            
        end

        % OpenBPButton button pushed function
        function OpenBPButtonButtonPushed(app)
            [filename, pathname] = uigetfile('*.*', 'Select Plot File', 'MultiSelect', 'on');
            app.UIFigure.Visible = 'off';
            app.UIFigure.Visible = 'on';
            app.Filepathfield.Value = fullfile(pathname);%, filename);
            
            BBB = length(filename)
            if isstr(filename);
                for index = 1;
                    temparray1 = dlmread(fullfile(pathname,filename),'',6,0);
                    temparray2 = [temparray1(1,1:end-1);temparray1(2,2:end)];
                    raw_data_cell{index} = temparray2;
                    fid = fopen(fullfile(pathname,filename{index}));
                    IDcell = textscan(fid,'%s','Delimiter','\t');
                    IDarray = IDcell{1};
                    IDarraytrunc(:,index) = IDarray(1:18);
                    fclose(fid);
                end
            else
                for index = 1:length(filename);
                    temparray1 = dlmread(fullfile(pathname,filename{index}),'',6,0);
                    temparray2 = [temparray1(1,1:end-1);temparray1(2,2:end)];
                    raw_data_cell{index} = temparray2;
                    fid = fopen(fullfile(pathname,filename{index}));
                    IDcell = textscan(fid,'%s','Delimiter','\t');
                    IDarray = IDcell{1};
                    IDarraytrunc(:,index) = IDarray(1:18);
                    fclose(fid);
                end
            end
            
            
            setappdata(app.UIFigure,'raw_data_cell',raw_data_cell);
            setappdata(app.UIFigure,'pathname',pathname)
            
            %
            %             transducerID = [''];
            %             if strcmp(IDarraytrunc(3),'')
            %                 app.instructionText.Value = 'No scan parameters loaded from file, please input manually.';
            %                 app.HPmodel0400.Value = 1;
            %                 app.gainvalhigh.Value = 1;
            %                 set(app.gainvalnone,'enable','off');
            %                 app.freq_in_mhz_input.Value = 1;
            %                 app.GraphTitleField.Value = filename;
            %             else
            %                 app.instructionText.Value = 'Scan parameters loaded from file, please verify accuracy.';
            %                 if strcmp(IDarraytrunc(4),'HNR-0500');
            %                     app.HPmodel0500.Value = 1;
            %                     set(app.gainvalnone,'enable','on');
            %                 elseif strcmp(IDarraytrunc(4),'HNP-0400');
            %                     app.HPmodel0400.Value = 1;
            %                     app.gainvalhigh.Value = 1;
            %                     set(app.gainvalnone,'enable','off')
            %                 elseif strcmp(IDarraytrunc(4),'HNP-0200');
            %                     app.HPmodel0200.Value = 1;
            %                     app.gainvalhigh.Value = 1;
            %                     set(app.gainvalnone,'enable','off')
            %                 end
            %
            %                 if strcmp(IDarraytrunc(6),'High');
            %                     app.gainvalhigh.Value = 1;
            %                 elseif strcmp(IDarraytrunc(6),'Low');
            %                     app.gainvallow.Value = 1;
            %                 elseif strcmp(IDarraytrunc(6),'None');
            %                     app.gainvalnone.Value = 1;
            %                 end
            %
            %                 app.Xoffsetvar.Value = cellfun(@str2num, IDarraytrunc(16));
            %                 app.Yoffsetvar.Value = cellfun(@str2num, IDarraytrunc(18));
            %                 app.freq_in_mhz_input.Value = cellfun(@str2num, IDarraytrunc(10));
            %                 transducerID = char(IDarraytrunc(2));
            %                 graphtitlestr = [transducerID,'—',filename];
            %                 app.GraphTitleField.Value = graphtitlestr;
            %             end
            %
            %             setappdata(app.UIFigure,'reldata',reldata);
            %             setappdata(app.UIFigure,'filename',filename);
            %             setappdata(app.UIFigure,'pathname',pathname);
            
            
            
        end

        % XlinesCheckBox value changed function
        function XlinesCheckBoxValueChanged(app)
            value = app.XlinesCheckBox.Value;
            if app.XlinesCheckBox.Value;
                set(app.Xlinesvar2,'enable','on');
            else
                set(app.Xlinesvar2,'enable','off');
            end
        end

        % YlinesCheckBox2 value changed function
        function YlinesCheckBox2ValueChanged(app)
            value = app.YlinesCheckBox2.Value;
            if app.YlinesCheckBox2.Value;
                set(app.Ylinesvar2,'enable','on');
            else
                set(app.Ylinesvar2,'enable','off');
            end            
        end

        % HPmodel selection change function
        function HPmodelSelectionChanged(app, event)
            selectedButton = app.HPmodel.SelectedObject;
            if app.HPmodel0200.Value;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
            elseif app.HPmodel0400.Value;
                app.gainvalhigh.Value = 1;
                set(app.gainvalnone,'enable','off');
            elseif app.HPmodel0500.Value;
                set(app.gainvalnone,'enable','on');
            end
            
        end

        % ColormapField value changed function
        function ColormapFieldValueChanged(app)
            colormapvalue = app.ColormapField.Value;
            
        end

        % MaxValuesCheckBox value changed function
        function MaxValuesCheckBoxValueChanged(app)
            value = app.MaxValuesCheckBox.Value;
            
        end

        % NormplotCheckBox value changed function
        function NormplotCheckBoxValueChanged(app)
            value = app.NormplotCheckBox.Value;
            
        end

        % Readme button pushed function
        function ReadmeButtonPushed(app)
            h = figure;
            hp = uipanel(h,'Title','Readme','FontSize',12,...
                'Position',[0 0 1 1]);
            btn = uicontrol(h,'Style', 'pushbutton', 'String', 'Close Readme',...
                'Position', [18 18 90 36],...
                'Callback', @closefigh);
            
            readmetextstr = {'this readme is incomplete.'...
                };
            
            readmetext = uicontrol('Style', 'text');
            readmetext.Parent = hp;
            readmetext.Units = 'normalized';
            %align(readmetext,'HorizontalAlignment','Left');
            readmetext.Position = [.03    .03    .94    .92];
            readmetext.FontSize = 10;
            readmetext.String = readmetextstr;
            
            function closefigh(source,event);
                close(h);
            end
            
            %                 Code for "advanced options" window in the future
            %                 advwindow = figure;
            %                 advpanel = uipanel
            %                     advpanel.Title = 'Advanced';
            %                     advpanel.BorderType = 'line';
            %                     advpanel.Title = 'Advanced Options';
            %                     advpanel.FontName = 'Helvetica';
            %                     advpanel.FontUnits = 'pixels';
            %                     advpanel.FontSize = 12;
            %                     advpanel.Units = 'normalized';
            %                     advpanel.Position = [0 0 1 1];
            
        end

        % Button button pushed function
        function ButtonButtonPushed(app)
            %
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 535 438];
            app.UIFigure.Name = '1D Hydrophone Scan Plotter';
            setAutoResize(app, app.UIFigure, true)

            % Create OpenBPButton
            app.OpenBPButton = uibutton(app.UIFigure, 'push');
            app.OpenBPButton.ButtonPushedFcn = createCallbackFcn(app, @OpenBPButtonButtonPushed);
            app.OpenBPButton.Position = [24 383 100 22];
            app.OpenBPButton.Text = 'Open Files';

            % Create HPmodel
            app.HPmodel = uibuttongroup(app.UIFigure);
            app.HPmodel.SelectionChangedFcn = createCallbackFcn(app, @HPmodelSelectionChanged, true);
            app.HPmodel.BorderType = 'line';
            app.HPmodel.Title = 'Hydrophone model';
            app.HPmodel.FontName = 'Helvetica';
            app.HPmodel.FontUnits = 'pixels';
            app.HPmodel.FontSize = 12;
            app.HPmodel.Units = 'pixels';
            app.HPmodel.Position = [227 251 123 106];

            % Create HPmodel0200
            app.HPmodel0200 = uiradiobutton(app.HPmodel);
            app.HPmodel0200.Text = 'HNP-0200';
            app.HPmodel0200.Position = [10 59 77 16];

            % Create HPmodel0400
            app.HPmodel0400 = uiradiobutton(app.HPmodel);
            app.HPmodel0400.Value = true;
            app.HPmodel0400.Text = 'HNP-0400';
            app.HPmodel0400.Position = [10 37 77 16];

            % Create HPmodel0500
            app.HPmodel0500 = uiradiobutton(app.HPmodel);
            app.HPmodel0500.Text = 'HNR-0500';
            app.HPmodel0500.Position = [10 15 78 16];

            % Create DCBgain
            app.DCBgain = uibuttongroup(app.UIFigure);
            app.DCBgain.BorderType = 'line';
            app.DCBgain.Title = 'DC Block Gain';
            app.DCBgain.FontName = 'Helvetica';
            app.DCBgain.FontUnits = 'pixels';
            app.DCBgain.FontSize = 12;
            app.DCBgain.Units = 'pixels';
            app.DCBgain.Position = [227 139 123 106];

            % Create gainvalhigh
            app.gainvalhigh = uiradiobutton(app.DCBgain);
            app.gainvalhigh.Value = true;
            app.gainvalhigh.Text = 'High';
            app.gainvalhigh.Position = [10 59 45 16];

            % Create gainvallow
            app.gainvallow = uiradiobutton(app.DCBgain);
            app.gainvallow.Text = 'Low';
            app.gainvallow.Position = [10 37 42 16];

            % Create gainvalnone
            app.gainvalnone = uiradiobutton(app.DCBgain);
            app.gainvalnone.Enable = 'off';
            app.gainvalnone.Text = 'None';
            app.gainvalnone.Position = [10 15 49 16];

            % Create LabelNumericEditField
            app.LabelNumericEditField = uilabel(app.UIFigure);
            app.LabelNumericEditField.HorizontalAlignment = 'right';
            app.LabelNumericEditField.Position = [44 339 94 15];
            app.LabelNumericEditField.Text = 'Frequency (MHz)';

            % Create freq_in_mhz_input
            app.freq_in_mhz_input = uieditfield(app.UIFigure, 'numeric');
            app.freq_in_mhz_input.Limits = [0 50];
            app.freq_in_mhz_input.ValueDisplayFormat = '%.2f';
            app.freq_in_mhz_input.Position = [147 335 54 22];
            app.freq_in_mhz_input.Value = 1;

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Enable = 'off';
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [42 177 97 15];
            app.Label.Text = 'X-axis offset (mm)';

            % Create Xoffsetvar
            app.Xoffsetvar = uieditfield(app.UIFigure, 'numeric');
            app.Xoffsetvar.Limits = [-500 500];
            app.Xoffsetvar.Enable = 'off';
            app.Xoffsetvar.Position = [147 173 54 22];

            % Create Label2
            app.Label2 = uilabel(app.UIFigure);
            app.Label2.Enable = 'off';
            app.Label2.HorizontalAlignment = 'right';
            app.Label2.Position = [41 143 97 15];
            app.Label2.Text = 'Y-axis offset (mm)';

            % Create Yoffsetvar
            app.Yoffsetvar = uieditfield(app.UIFigure, 'numeric');
            app.Yoffsetvar.Limits = [-500 500];
            app.Yoffsetvar.Enable = 'off';
            app.Yoffsetvar.Position = [147 139 54 22];

            % Create IntensitiesCheckBox
            app.IntensitiesCheckBox = uicheckbox(app.UIFigure);
            app.IntensitiesCheckBox.Text = 'Intensity Plot';
            app.IntensitiesCheckBox.Position = [372 256 88 16];
            app.IntensitiesCheckBox.Value = true;

            % Create GainCheckBox
            app.GainCheckBox = uicheckbox(app.UIFigure);
            app.GainCheckBox.Text = 'Gain Plot';
            app.GainCheckBox.Position = [372 228 69 16];
            app.GainCheckBox.Value = true;

            % Create PNGCheckBox
            app.PNGCheckBox = uicheckbox(app.UIFigure);
            app.PNGCheckBox.Text = 'Save .PNGs';
            app.PNGCheckBox.Position = [372 310 85 16];

            % Create TIFFCheckBox
            app.TIFFCheckBox = uicheckbox(app.UIFigure);
            app.TIFFCheckBox.Text = 'Save .TIFFs';
            app.TIFFCheckBox.Position = [372 282 83 16];

            % Create GeneratePlotButton
            app.GeneratePlotButton = uibutton(app.UIFigure, 'push');
            app.GeneratePlotButton.ButtonPushedFcn = createCallbackFcn(app, @GeneratePlotButtonButtonPushed);
            app.GeneratePlotButton.BackgroundColor = [0.9373 0.9373 0.9373];
            app.GeneratePlotButton.FontWeight = 'bold';
            app.GeneratePlotButton.Position = [207 21 138 47];
            app.GeneratePlotButton.Text = 'Generate Plot';

            % Create Readme
            app.Readme = uibutton(app.UIFigure, 'push');
            app.Readme.ButtonPushedFcn = createCallbackFcn(app, @ReadmeButtonPushed);
            app.Readme.FontSize = 10;
            app.Readme.FontAngle = 'italic';
            app.Readme.Position = [479 0 56 22];
            app.Readme.Text = 'Readme';

            % Create LabelEditField
            app.LabelEditField = uilabel(app.UIFigure);
            app.LabelEditField.HorizontalAlignment = 'right';
            app.LabelEditField.Position = [28 96 152 15];
            app.LabelEditField.Text = 'Edit Filename and Plot Title:';

            % Create GraphTitleField
            app.GraphTitleField = uieditfield(app.UIFigure, 'text');
            app.GraphTitleField.Position = [187 92 319 22];

            % Create Filepathfield
            app.Filepathfield = uieditfield(app.UIFigure, 'text');
            app.Filepathfield.Editable = 'off';
            app.Filepathfield.Position = [138 383 368 22];

            % Create MaxValuesCheckBox
            app.MaxValuesCheckBox = uicheckbox(app.UIFigure);
            app.MaxValuesCheckBox.ValueChangedFcn = createCallbackFcn(app, @MaxValuesCheckBoxValueChanged);
            app.MaxValuesCheckBox.Enable = 'off';
            app.MaxValuesCheckBox.Text = 'Display Max Values';
            app.MaxValuesCheckBox.Position = [372 171 127 16];

            % Create NormplotCheckBox
            app.NormplotCheckBox = uicheckbox(app.UIFigure);
            app.NormplotCheckBox.ValueChangedFcn = createCallbackFcn(app, @NormplotCheckBoxValueChanged);
            app.NormplotCheckBox.Enable = 'off';
            app.NormplotCheckBox.Text = 'Normalized Plot';
            app.NormplotCheckBox.Position = [372 199 106 16];

            % Create Label8
            app.Label8 = uilabel(app.UIFigure);
            app.Label8.HorizontalAlignment = 'right';
            app.Label8.Position = [81 242 57 15];
            app.Label8.Text = 'Power (W)';

            % Create powerfield
            app.powerfield = uieditfield(app.UIFigure, 'numeric');
            app.powerfield.Limits = [0 50];
            app.powerfield.ValueDisplayFormat = '%.2f';
            app.powerfield.Position = [147 238 54 22];
            app.powerfield.Value = 0.95;

            % Create Label9
            app.Label9 = uilabel(app.UIFigure);
            app.Label9.HorizontalAlignment = 'right';
            app.Label9.Position = [64 210 74 15];
            app.Label9.Text = 'Efficiency (%)';

            % Create efffield
            app.efffield = uieditfield(app.UIFigure, 'numeric');
            app.efffield.Limits = [0 100];
            app.efffield.Position = [147 206 54 22];
            app.efffield.Value = 10.15;

            % Create Label10
            app.Label10 = uilabel(app.UIFigure);
            app.Label10.HorizontalAlignment = 'right';
            app.Label10.Position = [46 275 92 15];
            app.Label10.Text = 'Tube height (cm)';

            % Create heightfield
            app.heightfield = uieditfield(app.UIFigure, 'numeric');
            app.heightfield.Limits = [0 50];
            app.heightfield.ValueDisplayFormat = '%.2f';
            app.heightfield.Position = [147 271 54 22];
            app.heightfield.Value = 0.76;

            % Create Label11
            app.Label11 = uilabel(app.UIFigure);
            app.Label11.HorizontalAlignment = 'right';
            app.Label11.Position = [46 307 92 15];
            app.Label11.Text = 'Tube radius (cm)';

            % Create radiusfield
            app.radiusfield = uieditfield(app.UIFigure, 'numeric');
            app.radiusfield.Limits = [0 50];
            app.radiusfield.ValueDisplayFormat = '%.2f';
            app.radiusfield.Position = [147 303 54 22];
            app.radiusfield.Value = 0.45;
        end
    end

    methods (Access = public)

        % Construct app
        function app = beamplot1Dv3()

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end

