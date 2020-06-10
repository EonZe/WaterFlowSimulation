classdef simulationGUI_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WaterflowsimulationUIFigure    matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        Image                          matlab.ui.control.Image
        PillarsPanel                   matlab.ui.container.Panel
        CenterpointPanel               matlab.ui.container.Panel
        XEditFieldLabel                matlab.ui.control.Label
        CenterX                        matlab.ui.control.NumericEditField
        YEditFieldLabel                matlab.ui.control.Label
        CenterY                        matlab.ui.control.NumericEditField
        DistancefromcenterEditFieldLabel  matlab.ui.control.Label
        DistFromCenter                 matlab.ui.control.NumericEditField
        NumberofpillarsEditFieldLabel  matlab.ui.control.Label
        PillarsNum                     matlab.ui.control.NumericEditField
        PillarradiusEditFieldLabel     matlab.ui.control.Label
        Pillarradius                   matlab.ui.control.NumericEditField
        GraphtypeButtonGroup           matlab.ui.container.ButtonGroup
        RotOption                      matlab.ui.control.RadioButton
        TanOption                      matlab.ui.control.RadioButton
        RUNButton                      matlab.ui.control.Button
        RESETButton                    matlab.ui.control.Button
        Panel                          matlab.ui.container.Panel
        CalculationboundsEditFieldLabel  matlab.ui.control.Label
        CalcBounds                     matlab.ui.control.NumericEditField
        CalculationstepEditFieldLabel  matlab.ui.control.Label
        CalcStep                       matlab.ui.control.NumericEditField
        RightPanel                     matlab.ui.container.Panel
        Graph                          matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)
        vr; % Description
        vv;
        vr1;
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           [app.vr,app.vv,app.vr1]=integral1();
            colorbar(app.Graph);
            title(app.Graph,'READY!');
        end

        % Button pushed function: RUNButton
        function onRunBtnPressed(app, event)
            title(app.Graph,'calculating...');
                app.RUNButton.Enable=false;
                pause(0.01);
                cla(app.Graph);
                CENTER=[app.CenterY.Value,app.CenterX.Value];
                MIDRAD=app.DistFromCenter.Value;
                NUM_STEB=app.PillarsNum.Value;
                RSTEB=app.Pillarradius.Value;
                MAX=app.CalcBounds.Value;
                STEP=app.CalcStep.Value;
            
            j=app.vv;
            k=app.vr1;
            
            if app.RotOption.Value == true
                py=j./k;
                titleStr='Rotational speed v_r';
            else
                py=j;
                titleStr='Tangential speed v_0';
            end
      
            [X,Y,scalars,xs,ys]=getData(app.vr,py,CENTER,MIDRAD, NUM_STEB,RSTEB,MAX,STEP);
            hold(app.Graph,'on')
            
            h=pcolor(app.Graph,X, Y, scalars);
            h.FaceColor = 'interp';
            set(h, 'EdgeColor', 'none');
            
            title(app.Graph,titleStr)
            
            quiver(app.Graph,X,Y,xs,ys) %risanje vektorjev
            hold(app.Graph,'off')
            app.RUNButton.Enable=true;
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.WaterflowsimulationUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {230, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
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
            title(app.Graph,'Obtaining data...');
            pause(0.1);
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
            app.WaterflowsimulationUIFigure.Position = [100 100 640 480];
            app.WaterflowsimulationUIFigure.Name = 'Water flow simulation';
            app.WaterflowsimulationUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.WaterflowsimulationUIFigure);
            app.GridLayout.ColumnWidth = {230, '1x'};
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
            app.Image.Position = [2 379 213 100];
            app.Image.ImageSource = 'FERI_logo.png';

            % Create PillarsPanel
            app.PillarsPanel = uipanel(app.LeftPanel);
            app.PillarsPanel.Title = 'Pillars';
            app.PillarsPanel.Position = [7 190 217 200];

            % Create CenterpointPanel
            app.CenterpointPanel = uipanel(app.PillarsPanel);
            app.CenterpointPanel.Title = 'Center point';
            app.CenterpointPanel.Position = [1 119 216 60];

            % Create XEditFieldLabel
            app.XEditFieldLabel = uilabel(app.CenterpointPanel);
            app.XEditFieldLabel.HorizontalAlignment = 'right';
            app.XEditFieldLabel.Position = [4 9 25 22];
            app.XEditFieldLabel.Text = 'X';

            % Create CenterX
            app.CenterX = uieditfield(app.CenterpointPanel, 'numeric');
            app.CenterX.Tag = 'Cx';
            app.CenterX.Position = [33 9 54 22];

            % Create YEditFieldLabel
            app.YEditFieldLabel = uilabel(app.CenterpointPanel);
            app.YEditFieldLabel.HorizontalAlignment = 'right';
            app.YEditFieldLabel.Position = [115 9 25 22];
            app.YEditFieldLabel.Text = 'Y';

            % Create CenterY
            app.CenterY = uieditfield(app.CenterpointPanel, 'numeric');
            app.CenterY.Tag = 'Cy';
            app.CenterY.Position = [144 9 54 22];

            % Create DistancefromcenterEditFieldLabel
            app.DistancefromcenterEditFieldLabel = uilabel(app.PillarsPanel);
            app.DistancefromcenterEditFieldLabel.HorizontalAlignment = 'right';
            app.DistancefromcenterEditFieldLabel.Position = [1 71 116 22];
            app.DistancefromcenterEditFieldLabel.Text = 'Distance from center';

            % Create DistFromCenter
            app.DistFromCenter = uieditfield(app.PillarsPanel, 'numeric');
            app.DistFromCenter.Limits = [0 Inf];
            app.DistFromCenter.Tag = 'Center_dist';
            app.DistFromCenter.Position = [124 71 79 22];
            app.DistFromCenter.Value = 120;

            % Create NumberofpillarsEditFieldLabel
            app.NumberofpillarsEditFieldLabel = uilabel(app.PillarsPanel);
            app.NumberofpillarsEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofpillarsEditFieldLabel.Position = [1 44 94 22];
            app.NumberofpillarsEditFieldLabel.Text = 'Number of pillars';

            % Create PillarsNum
            app.PillarsNum = uieditfield(app.PillarsPanel, 'numeric');
            app.PillarsNum.Limits = [1 Inf];
            app.PillarsNum.RoundFractionalValues = 'on';
            app.PillarsNum.Tag = 'Pillar_num';
            app.PillarsNum.Position = [123 44 80 22];
            app.PillarsNum.Value = 8;

            % Create PillarradiusEditFieldLabel
            app.PillarradiusEditFieldLabel = uilabel(app.PillarsPanel);
            app.PillarradiusEditFieldLabel.HorizontalAlignment = 'right';
            app.PillarradiusEditFieldLabel.Position = [1 14 94 22];
            app.PillarradiusEditFieldLabel.Text = 'Pillar radius';

            % Create Pillarradius
            app.Pillarradius = uieditfield(app.PillarsPanel, 'numeric');
            app.Pillarradius.Limits = [0 Inf];
            app.Pillarradius.Tag = 'Pillar_r';
            app.Pillarradius.Position = [123 14 80 22];
            app.Pillarradius.Value = 40;

            % Create GraphtypeButtonGroup
            app.GraphtypeButtonGroup = uibuttongroup(app.LeftPanel);
            app.GraphtypeButtonGroup.Title = 'Graph type';
            app.GraphtypeButtonGroup.Tag = 'GraphType';
            app.GraphtypeButtonGroup.Position = [7 16 118 67];

            % Create RotOption
            app.RotOption = uiradiobutton(app.GraphtypeButtonGroup);
            app.RotOption.Tag = 'GT_rot';
            app.RotOption.Text = 'Rotational Speed';
            app.RotOption.Position = [1 23 114 22];
            app.RotOption.Value = true;

            % Create TanOption
            app.TanOption = uiradiobutton(app.GraphtypeButtonGroup);
            app.TanOption.Tag = 'GT_tan';
            app.TanOption.Text = 'Tangential speed';
            app.TanOption.Position = [1 1 113 22];

            % Create RUNButton
            app.RUNButton = uibutton(app.LeftPanel, 'push');
            app.RUNButton.ButtonPushedFcn = createCallbackFcn(app, @onRunBtnPressed, true);
            app.RUNButton.Tag = 'RunBtn';
            app.RUNButton.Position = [127 61 100 22];
            app.RUNButton.Text = 'RUN';

            % Create RESETButton
            app.RESETButton = uibutton(app.LeftPanel, 'push');
            app.RESETButton.ButtonPushedFcn = createCallbackFcn(app, @RESETButtonPushed, true);
            app.RESETButton.Tag = 'RunBtn';
            app.RESETButton.Position = [126 30 100 22];
            app.RESETButton.Text = 'RESET';

            % Create Panel
            app.Panel = uipanel(app.LeftPanel);
            app.Panel.Title = 'Panel';
            app.Panel.Position = [7 96 217 93];

            % Create CalculationboundsEditFieldLabel
            app.CalculationboundsEditFieldLabel = uilabel(app.Panel);
            app.CalculationboundsEditFieldLabel.HorizontalAlignment = 'right';
            app.CalculationboundsEditFieldLabel.Position = [4 47 116 22];
            app.CalculationboundsEditFieldLabel.Text = 'Calculation bounds';

            % Create CalcBounds
            app.CalcBounds = uieditfield(app.Panel, 'numeric');
            app.CalcBounds.Limits = [0 Inf];
            app.CalcBounds.Tag = 'Calc_bound';
            app.CalcBounds.Position = [127 47 88 22];
            app.CalcBounds.Value = 200;

            % Create CalculationstepEditFieldLabel
            app.CalculationstepEditFieldLabel = uilabel(app.Panel);
            app.CalculationstepEditFieldLabel.HorizontalAlignment = 'right';
            app.CalculationstepEditFieldLabel.Position = [5 19 116 22];
            app.CalculationstepEditFieldLabel.Text = 'Calculation step';

            % Create CalcStep
            app.CalcStep = uieditfield(app.Panel, 'numeric');
            app.CalcStep.Limits = [0 Inf];
            app.CalcStep.Tag = 'Calc_step';
            app.CalcStep.Position = [128 19 87 22];
            app.CalcStep.Value = 5;

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
            app.Graph.Position = [6 6 403 473];

            % Show the figure after all components are created
            app.WaterflowsimulationUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = simulationGUI_exported

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