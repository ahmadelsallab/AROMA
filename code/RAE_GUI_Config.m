function varargout = RAE_GUI_Config(varargin)
% RAE_GUI_Config MATLAB code for RAE_GUI_Config.fig
%      RAE_GUI_Config, by itself, creates a new RAE_GUI_Config or raises the existing
%      singleton*.
%
%      H = RAE_GUI_Config returns the handle to a new RAE_GUI_Config or the handle to
%      the existing singleton*.
%
%      RAE_GUI_Config('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAE_GUI_Config.M with the given input arguments.
%
%      RAE_GUI_Config('Property','Value',...) creates a new RAE_GUI_Config or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the RAE_GUI_Config before RAE_GUI_Config_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RAE_GUI_Config_OpeningFcn via varargin.
%
%      *See RAE_GUI_Config Options on GUIDE's Tools menu.  Choose "RAE_GUI_Config allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RAE_GUI_Config

% Last Modified by GUIDE v2.5 10-Sep-2015 16:31:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RAE_GUI_Config_OpeningFcn, ...
                   'gui_OutputFcn',  @RAE_GUI_Config_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONFIGURATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%
global CONFIG_strParamsGUI;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END CONFIGURATIONS %%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% CONTROLS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before RAE_GUI_Config is made visible.
function RAE_GUI_Config_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RAE_GUI_Config (see VARARGIN)

% Choose default command line output for RAE_GUI_Config
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RAE_GUI_Config wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RAE_GUI_Config_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function sSupervisedDataSetPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sSupervisedDataSetPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function sAnnotationsFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sAnnotationsFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bWordEmbedding.
function bWordEmbedding_Callback(hObject, eventdata, handles)
% hObject    handle to bWordEmbedding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bWordEmbedding
    if(get(hObject,'Value') == 1)
        set(handles.embedding_pannel,'Visible','on');
    else
        set(handles.embedding_pannel,'Visible','off');
    end




% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function nMaxNumLines_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nMaxNumLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function sActivationfunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sActivationfunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function nEmbeddingSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nEmbeddingSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function vLayersSizes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vLayersSizes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function sIndicesFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sIndicesFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function sVocabularyFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sVocabularyFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    

    fprintf(1, 'Configuring...\n');

    % Start Configuration
    CONFIG_setConfigParams(handles);

    fprintf(1, 'Configuration done successfuly\n');
    
    % Change directory to go there
    global CONFIG_strParamsGUI;
    cd(CONFIG_strParamsGUI.sDefaultClassifierPath);

    % Call main entry function of the classifier
    %MAIN_trainAndClassify(CONFIG_strParamsGUI);
    
    % Decide which experiment to run
    
    % Raw experiment
    if(CONFIG_strParamsGUI.bWordEmbedding == 0)
        run_ATB;
    % Separate words embedding
    elseif (CONFIG_strParamsGUI.bNgramValidWe == 1)
        full_training_separate_We; % run_Qalb_ATB.m
    % Lexicon embeddings    
    elseif (CONFIG_strParamsGUI.bLexiconEmbedding == 1)
        full_training_ArSenL_Embedding;
        
    % Merge of lexicon and word embeddings
    elseif (CONFIG_strParamsGUI.bMergeLexiconNgram == 1)
        switch(CONFIG_strParamsGUI.sMergeOption)
            case 'Features level'
                full_training_ArsenL_We;
            case 'Decision level'
                full_training_ArsenL_We_Decision_Level_Merge_Softmax;                
        end
    end
    
    

% --- Executes on button press in run_embedding.
function run_embedding_Callback(hObject, eventdata, handles)
% hObject    handle to run_embedding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in run_RAE.
function run_RAE_Callback(hObject, eventdata, handles)
% hObject    handle to run_RAE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function nMaxIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nMaxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [FileName,PathName] = uigetfile('*','Select the raw text file');
    set(handles.sSupervisedDataSetPath, 'String', [PathName FileName]);
    global CONFIG_strParamsGUI;
    CONFIG_strParamsGUI.sDatasetFilesPath = PathName;

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [FileName,PathName] = uigetfile('*','Select the annotations file');
    set(handles.sSupervisedDataSetPath, 'String', [PathName FileName]);

% --- Executes during object creation, after setting all properties.
function sUnsupervisedWeDatasetPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sUnsupervisedWeDatasetPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%% END CONTROLS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% PRIVATE FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CONFIG_setConfigParams(handles)
    global CONFIG_strParamsGUI;
    
    % Set the path to the classifier, which is the same path in case of RAE
    CONFIG_strParamsGUI.sDefaultClassifierPath = pwd;
    
    % Configuration of the dataset to be used
    % ATB_Senti_RAE
    CONFIG_strParamsGUI.sDataset = 'ATB_Senti_RAE';
    
    % Full path to the raw txt dataset. Each line is a separate case.
    CONFIG_strParamsGUI.sSupervisedDataSetPath = get(handles.sSupervisedDataSetPath, 'String');
     
    % Full path to the annotations associated with the sSupervisedDataSetPath
    CONFIG_strParamsGUI.sAnnotationsFilePath = get(handles.sAnnotationsFilePath, 'String');
     
    % The max number of iterations in RAE training
    CONFIG_strParamsGUI.nMaxIter  = eval(get(handles.nMaxIter, 'String'));
     
    % Flag to indicate whether separate embedding block is needed
    CONFIG_strParamsGUI.bWordEmbedding = get(handles.bWordEmbedding, 'Value');

          % The acitvation used in word embedding training
          contents = get(handles.sActivationfunction,'String'); 
          CONFIG_strParamsGUI.sActivationfunction = contents{get(handles.sActivationfunction,'Value')};
          
          % Embedding size
          CONFIG_strParamsGUI.nEmbeddingSize = eval(get(handles.nEmbeddingSize, 'String'));
          
          % The widths of layers. In case of list, explicit '[ ]' must be
          % put
          CONFIG_strParamsGUI.vLayersSizes = eval(get(handles.vLayersSizes, 'String'));
          
          % N-gram validity We
          CONFIG_strParamsGUI.bNgramValidWe = get(handles.bNgramValidWe, 'Value');
          
              % The path to the unsupervised dataset (Qalb for example)
              CONFIG_strParamsGUI.sUnsupervisedWeDatasetPath = get(handles.sUnsupervisedWeDatasetPath, 'String');

              % The max. number of lines to parse from the unsupervised dataset (Qalb for example)
              CONFIG_strParamsGUI.nMaxNumLines = eval(get(handles.nMaxNumLines, 'String'));
          
          % blexiconembedding embedding
          CONFIG_strParamsGUI.bLexiconEmbedding = get(handles.bLexiconEmbedding, 'Value');
          
            % Flag to indicate if we need to include the objective score in
            % case of sentiment
            CONFIG_strParamsGUI.bLexiconEmbeddingObjectiveScoreIncluded = get(handles.bLexiconEmbeddingObjectiveScoreIncluded, 'Value');
            
            % Path to indices file mapped to bLexiconEmbedding entries
            CONFIG_strParamsGUI.sIndicesFilePath = get(handles.sIndicesFilePath, 'String');
            
            % Path to sVocabularyFilePath file
            CONFIG_strParamsGUI.sVocabularyFilePath = get(handles.sVocabularyFilePath, 'String');
            
        % Flag to indicate to merge bLexiconEmbedding with word embedding
        CONFIG_strParamsGUI.bMergeLexiconNgram = get(handles.bMergeLexiconNgram, 'Value');

            % Flag to indicate to merge at features 
            CONFIG_strParamsGUI.sMergeOption = (get(get(handles.sMergeOption,'SelectedObject'),'Tag'));
                
       % Flag to indicate if separate parser was used to get ready parse
       % trees
       CONFIG_strParamsGUI.bKnownParsing = get(handles.bKnownParsing, 'Value');
            % Get the path to the known parse trees
            CONFIG_strParamsGUI.sParseFilePath = get(handles.sParseFilePath, 'String');


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in bKnownParsing.
function bKnownParsing_Callback(hObject, eventdata, handles)
% hObject    handle to bKnownParsing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bKnownParsing
    if(get(hObject,'Value') == 1)
        set(handles.parse_tree_panel,'Visible','on');
    else
        set(handles.parse_tree_panel,'Visible','off');
    end

% --- Executes during object creation, after setting all properties.
function sParseFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sParseFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [FileName,PathName] = uigetfile('*','Select the parse trees file');
    set(handles.sParseFilePath, 'String', [PathName FileName]);
