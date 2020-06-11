classdef simulationGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WaterflowsimulationUIFigure    matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        Image                          matlab.ui.control.Image
        TabGroup                       matlab.ui.container.TabGroup
        ScenesetupTab                  matlab.ui.container.Tab
        PillarsPanel                   matlab.ui.container.Panel
        CenterpointPanel               matlab.ui.container.Panel
        XEditFieldLabel                matlab.ui.control.Label
        CenterX                        matlab.ui.control.NumericEditField
        YEditFieldLabel                matlab.ui.control.Label
        CenterY                        matlab.ui.control.NumericEditField
        DistancefromcenterLabel        matlab.ui.control.Label
        DistFromCenter                 matlab.ui.control.NumericEditField
        NumberofpillarsEditFieldLabel  matlab.ui.control.Label
        PillarsNum                     matlab.ui.control.NumericEditField
        PillarradiusEditFieldLabel     matlab.ui.control.Label
        Pillarradius                   matlab.ui.control.NumericEditField
        GraphtypeButtonGroup           matlab.ui.container.ButtonGroup
        RotOption                      matlab.ui.control.RadioButton
        TanOption                      matlab.ui.control.RadioButton
        CalculationPanel               matlab.ui.container.Panel
        CalculationboundsEditFieldLabel  matlab.ui.control.Label
        CalcBounds                     matlab.ui.control.NumericEditField
        CalculationstepEditFieldLabel  matlab.ui.control.Label
        CalcStep                       matlab.ui.control.NumericEditField
        SpeedCalculationTab            matlab.ui.container.Tab
        VibrationPanel                 matlab.ui.container.Panel
        AmplitudeEditFieldLabel        matlab.ui.control.Label
        AmplitudeInput                 matlab.ui.control.NumericEditField
        FrequencyEditFieldLabel        matlab.ui.control.Label
        FrequencyInput                 matlab.ui.control.NumericEditField
        MaterialPanel                  matlab.ui.container.Panel
        DynamicviscosityLabel          matlab.ui.control.Label
        niInput                        matlab.ui.control.NumericEditField
        RUNButton                      matlab.ui.control.Button
        RESETButton                    matlab.ui.control.Button
        RightPanel                     matlab.ui.container.Panel
        Graph                          matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            colorbar(app.Graph);
            title(app.Graph,'READY!');
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.WaterflowsimulationUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {551, 551};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {257, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Button pushed function: RUNButton
        function onRunBtnPressed(app, event)
            title(app.Graph,'calculating...');
            app.RUNButton.Enable=false;
            app.RESETButton.Enable=false;
            pause(0.01);
                
            cla(app.Graph);
            CENTER=[app.CenterY.Value,app.CenterX.Value];
            MIDRAD=app.DistFromCenter.Value;
            NUM_STEB=app.PillarsNum.Value;
            RSTEB=app.Pillarradius.Value;
            MAX=app.CalcBounds.Value;
            STEP=app.CalcStep.Value;
            
            a=RSTEB*1E-6;
            dr=5E-6*STEP;
            A=app.AmplitudeInput.Value*1E-6;
            ni=app.niInput.Value;
            f=app.FrequencyInput.Value;
            [vr,vv,vr1]=integral1(A,a,dr,ni,f);
            
            if app.RotOption.Value == true
                py=vv./vr1;
                titleStr='Rotational speed v_r';
            else
                py=vv;
                titleStr='Tangential speed v_0';
            end
      
            [X,Y,scalars,xs,ys]=getData(vr,py,CENTER,MIDRAD, NUM_STEB,RSTEB,MAX,STEP);
            hold(app.Graph,'on')
            
            h=pcolor(app.Graph,X, Y, scalars);
            h.FaceColor = 'interp';
            set(h, 'EdgeColor', 'none');
            
            title(app.Graph,titleStr)
            
            quiver(app.Graph,X,Y,xs,ys) %risanje vektorjev
            hold(app.Graph,'off')
            app.RUNButton.Enable=true;
            app.RESETButton.Enable=true;
        end

        % Button pushed function: RESETButton
        function RESETButtonPushed(app, event)
            cla(app.Graph);
            app.CenterY.Value=0;
            app.CenterX.Value=0;
            app.DistFromCenter.Value=120;
            app.PillarsNum.Value=8;
            app.Pillarradius.Value=40;
            app.CalcBounds.Value=200;
            app.CalcStep.Value=5;
            app.AmplitudeInput.Value=8;
            app.niInput.Value=1e-6;
            app.FrequencyInput.Value=1000;
            
            title(app.Graph,'READY!');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create WaterflowsimulationUIFigure and hide until all components are created
            app.WaterflowsimulationUIFigure = uifigure('Visible', 'off');
            app.WaterflowsimulationUIFigure.AutoResizeChildren = 'off';
            app.WaterflowsimulationUIFigure.Position = [100 100 737 551];
            app.WaterflowsimulationUIFigure.Name = 'Water flow simulation';
            app.WaterflowsimulationUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.WaterflowsimulationUIFigure);
            app.GridLayout.ColumnWidth = {257, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create Image
            app.Image = uiimage(app.LeftPanel);
            app.Image.Position = [19 448 213 100];
            app.Image.ImageSource = 'FERI_logo.png';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.LeftPanel);
            app.TabGroup.Position = [2 1 249 412];

            % Create ScenesetupTab
            app.ScenesetupTab = uitab(app.TabGroup);
            app.ScenesetupTab.Title = 'Scene setup';

            % Create PillarsPanel
            app.PillarsPanel = uipanel(app.ScenesetupTab);
            app.PillarsPanel.Title = 'Pillars';
            app.PillarsPanel.Position = [1 187 248 200];

            % Create CenterpointPanel
            app.CenterpointPanel = uipanel(app.PillarsPanel);
            app.CenterpointPanel.Title = 'Center point';
            app.CenterpointPanel.Position = [0 119 244 60];

            % Create XEditFieldLabel
            app.XEditFieldLabel = uilabel(app.CenterpointPanel);
            app.XEditFieldLabel.HorizontalAlignment = 'right';
            app.XEditFieldLabel.Position = [4 9 25 22];
            app.XEditFieldLabel.Text = 'X';

            % Create CenterX
            app.CenterX = uieditfield(app.CenterpointPanel, 'numeric');
            app.CenterX.ValueDisplayFormat = '%11.4g ÿm';
            app.CenterX.Tag = 'Cx';
            app.CenterX.Position = [33 9 80 22];

            % Create YEditFieldLabel
            app.YEditFieldLabel = uilabel(app.CenterpointPanel);
            app.YEditFieldLabel.HorizontalAlignment = 'right';
            app.YEditFieldLabel.Position = [132 9 25 22];
            app.YEditFieldLabel.Text = 'Y';

            % Create CenterY
            app.CenterY = uieditfield(app.CenterpointPanel, 'numeric');
            app.CenterY.ValueDisplayFormat = '%11.4g ÿm';
            app.CenterY.Tag = 'Cy';
            app.CenterY.Position = [161 9 78 22];

            % Create DistancefromcenterLabel
            app.DistancefromcenterLabel = uilabel(app.PillarsPanel);
            app.DistancefromcenterLabel.Position = [6 71 119 22];
            app.DistancefromcenterLabel.Text = 'Distance from center ';

            % Create DistFromCenter
            app.DistFromCenter = uieditfield(app.PillarsPanel, 'numeric');
            app.DistFromCenter.Limits = [0 Inf];
            app.DistFromCenter.ValueDisplayFormat = '%11.4g ÿm';
            app.DistFromCenter.Tag = 'Center_dist';
            app.DistFromCenter.Position = [132 71 116 22];
            app.DistFromCenter.Value = 120;

            % Create NumberofpillarsEditFieldLabel
            app.NumberofpillarsEditFieldLabel = uilabel(app.PillarsPanel);
            app.NumberofpillarsEditFieldLabel.Position = [5 44 94 22];
            app.NumberofpillarsEditFieldLabel.Text = 'Number of pillars';

            % Create PillarsNum
            app.PillarsNum = uieditfield(app.PillarsPanel, 'numeric');
            app.PillarsNum.Limits = [1 Inf];
            app.PillarsNum.RoundFractionalValues = 'on';
            app.PillarsNum.Tag = 'Pillar_num';
            app.PillarsNum.Position = [132 44 116 22];
            app.PillarsNum.Value = 8;

            % Create PillarradiusEditFieldLabel
            app.PillarradiusEditFieldLabel = uilabel(app.PillarsPanel);
            app.PillarradiusEditFieldLabel.Position = [6 14 94 22];
            app.PillarradiusEditFieldLabel.Text = 'Pillar radius';

            % Create Pillarradius
            app.Pillarradius = uieditfield(app.PillarsPanel, 'numeric');
            app.Pillarradius.Limits = [0 Inf];
            app.Pillarradius.ValueDisplayFormat = '%11.4g ÿm';
            app.Pillarradius.Tag = 'Pillar_r';
            app.Pillarradius.Position = [132 14 116 22];
            app.Pillarradius.Value = 40;

            % Create GraphtypeButtonGroup
            app.GraphtypeButtonGroup = uibuttongroup(app.ScenesetupTab);
            app.GraphtypeButtonGroup.Title = 'Graph type';
            app.GraphtypeButtonGroup.Tag = 'GraphType';
            app.GraphtypeButtonGroup.Position = [0 1 249 92];

            % Create RotOption
            app.RotOption = uiradiobutton(app.GraphtypeButtonGroup);
            app.RotOption.Tag = 'GT_rot';
            app.RotOption.Text = 'Rotational Speed';
            app.RotOption.Position = [1 48 114 22];
            app.RotOption.Value = true;

            % Create TanOption
            app.TanOption = uiradiobutton(app.GraphtypeButtonGroup);
            app.TanOption.Tag = 'GT_tan';
            app.TanOption.Text = 'Tangential speed';
            app.TanOption.Position = [1 26 113 22];

            % Create CalculationPanel
            app.CalculationPanel = uipanel(app.ScenesetupTab);
            app.CalculationPanel.Title = 'Calculation';
            app.CalculationPanel.Position = [2 95 247 93];

            % Create CalculationboundsEditFieldLabel
            app.CalculationboundsEditFieldLabel = uilabel(app.CalculationPanel);
            app.CalculationboundsEditFieldLabel.Position = [5 47 116 22];
            app.CalculationboundsEditFieldLabel.Text = 'Calculation bounds';

            % Create CalcBounds
            app.CalcBounds = uieditfield(app.CalculationPanel, 'numeric');
            app.CalcBounds.Limits = [0 Inf];
            app.CalcBounds.ValueDisplayFormat = '%11.4g ÿm';
            app.CalcBounds.Tag = 'Calc_bound';
            app.CalcBounds.Position = [131 47 114 22];
            app.CalcBounds.Value = 200;

            % Create CalculationstepEditFieldLabel
            app.CalculationstepEditFieldLabel = uilabel(app.CalculationPanel);
            app.CalculationstepEditFieldLabel.Position = [5 19 116 22];
            app.CalculationstepEditFieldLabel.Text = 'Calculation step';

            % Create CalcStep
            app.CalcStep = uieditfield(app.CalculationPanel, 'numeric');
            app.CalcStep.Limits = [0 Inf];
            app.CalcStep.ValueDisplayFormat = '%11.4g ÿm';
            app.CalcStep.Tag = 'Calc_step';
            app.CalcStep.Position = [131 19 116 22];
            app.CalcStep.Value = 5;

            % Create SpeedCalculationTab
            app.SpeedCalculationTab = uitab(app.TabGroup);
            app.SpeedCalculationTab.Title = 'Speed Calculation';

            % Create VibrationPanel
            app.VibrationPanel = uipanel(app.SpeedCalculationTab);
            app.VibrationPanel.Title = 'Vibration';
            app.VibrationPanel.Position = [1 279 246 100];

            % Create AmplitudeEditFieldLabel
            app.AmplitudeEditFieldLabel = uilabel(app.VibrationPanel);
            app.AmplitudeEditFieldLabel.HorizontalAlignment = 'right';
            app.AmplitudeEditFieldLabel.Position = [65 57 59 22];
            app.AmplitudeEditFieldLabel.Text = 'Amplitude';

            % Create AmplitudeInput
            app.AmplitudeInput = uieditfield(app.VibrationPanel, 'numeric');
            app.AmplitudeInput.Limits = [0 Inf];
            app.AmplitudeInput.ValueDisplayFormat = '%11.4g ÿm';
            app.AmplitudeInput.Position = [139 57 100 22];
            app.AmplitudeInput.Value = 8;

            % Create FrequencyEditFieldLabel
            app.FrequencyEditFieldLabel = uilabel(app.VibrationPanel);
            app.FrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.FrequencyEditFieldLabel.Position = [65 15 62 22];
            app.FrequencyEditFieldLabel.Text = 'Frequency';

            % Create FrequencyInput
            app.FrequencyInput = uieditfield(app.VibrationPanel, 'numeric');
            app.FrequencyInput.Limits = [0 Inf];
            app.FrequencyInput.ValueDisplayFormat = '%11.4g Hz';
            app.FrequencyInput.Position = [142 15 100 22];
            app.FrequencyInput.Value = 1000;

            % Create MaterialPanel
            app.MaterialPanel = uipanel(app.SpeedCalculationTab);
            app.MaterialPanel.Title = 'Material';
            app.MaterialPanel.Position = [1 187 246 83];

            % Create DynamicviscosityLabel
            app.DynamicviscosityLabel = uilabel(app.MaterialPanel);
            app.DynamicviscosityLabel.HorizontalAlignment = 'right';
            app.DynamicviscosityLabel.Position = [26 24 101 22];
            app.DynamicviscosityLabel.Text = 'Dynamic viscosity';

            % Create niInput
            app.niInput = uieditfield(app.MaterialPanel, 'numeric');
            app.niInput.Limits = [0 Inf];
            app.niInput.ValueDisplayFormat = '%11.4g Ns/m^2';
            app.niInput.Position = [142 24 100 22];
            app.niInput.Value = 1e-06;

            % Create RUNButton
            app.RUNButton = uibutton(app.LeftPanel, 'push');
            app.RUNButton.ButtonPushedFcn = createCallbackFcn(app, @onRunBtnPressed, true);
            app.RUNButton.Tag = 'RunBtn';
            app.RUNButton.Position = [17 433 100 22];
            app.RUNButton.Text = 'RUN';

            % Create RESETButton
            app.RESETButton = uibutton(app.LeftPanel, 'push');
            app.RESETButton.ButtonPushedFcn = createCallbackFcn(app, @RESETButtonPushed, true);
            app.RESETButton.Tag = 'RunBtn';
            app.RESETButton.Position = [139 433 100 22];
            app.RESETButton.Text = 'RESET';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create Graph
            app.Graph = uiaxes(app.RightPanel);
            title(app.Graph, 'Loading...')
            xlabel(app.Graph, 'X [\mum]')
            ylabel(app.Graph, 'Y [\mum]')
            app.Graph.DataAspectRatio = [1 1 1];
            app.Graph.PlotBoxAspectRatio = [1 1 1];
            app.Graph.GridColor = 'none';
            app.Graph.MinorGridColor = 'none';
            app.Graph.Position = [6 42 468 506];

            % Show the figure after all components are created
            app.WaterflowsimulationUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = simulationGUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.WaterflowsimulationUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.WaterflowsimulationUIFigure)
        end
    end
end