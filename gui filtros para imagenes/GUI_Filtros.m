function varargout = GUI_Filtros(varargin)
% GUI_FILTROS MATLAB code for GUI_Filtros.fig
%      GUI_FILTROS, by itself, creates a new GUI_FILTROS or raises the existing
%      singleton*.
%
%      H = GUI_FILTROS returns the handle to a new GUI_FILTROS or the handle to
%      the existing singleton*.
%
%      GUI_FILTROS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FILTROS.M with the given input arguments.
%
%      GUI_FILTROS('Property','Value',...) creates a new GUI_FILTROS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Filtros_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Filtros_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menuprincipal.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Filtros

% Last Modified by GUIDE v2.5 13-Jul-2017 19:21:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_Filtros_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_Filtros_OutputFcn, ...
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


% --- Executes just before GUI_Filtros is made visible.
function GUI_Filtros_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Filtros (see VARARGIN)

% Choose default command line output for GUI_Filtros
handles.output = hObject;

%cargar imagen de logo
imagen=imread('logo2.png');
imagesc(imagen, 'Parent', handles.Logo);
axes(handles.Logo)
axis off; %desabilitar ejes coordenados
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Filtros wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Filtros_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Cargar.
function Cargar_Callback(hObject, eventdata, handles)
% hObject    handle to Cargar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile('*.jpg','File Selector'); % Buscar imagen de forma gráfica
fullpathname1 = strcat(pathname, filename);  % Obtener direccion
handles.filename1 = filename;

I= imread(fullpathname1);
handles.I = I;
handles.color_o_gris = size(handles.I,3);%saber si es imagen a color o escala de grises
if(handles.color_o_gris==3)%si es color
    imagesc(handles.I, 'Parent', handles.Imagen1);
     set(handles.checkbox2,'Value',0);
   set(handles.checkbox1,'Value',0);
   set(handles.checkbox2,'enable','on');
   set(handles.checkbox1,'enable','on');
else%es gris
   imagesc(handles.I, 'Parent', handles.Imagen1),colormap(gray);%Cargar Imagen
   handles.Ioriginal=handles.I;
   set(handles.checkbox2,'Value',1);
   set(handles.checkbox1,'Value',0);
   set(handles.checkbox2,'enable','off');
   set(handles.checkbox1,'enable','off');
   set(handles.Menu1,'enable','on');%habilitar menu1
   set(handles.grupo2,'Visible','off');%ocultar opcion para filtro
   set(handles.Menu2,'String',{'Filtro de la Mediana','Deteccion de Bordes','Richardson-lucy','Landweber','VanCitter','Filtro Bilateral','Erosion','Dilatacion','Cartoon'});%seteamos valores filtros escala de grises
   
   
end


axes(handles.Imagen1);
axis off; %desabilitar ejes coordenados
set(handles.sigma, 'String',0.05);
set(handles.checkbox1,'Visible','on');%activar checkbox1
set(handles.checkbox2,'Visible','on');%activar checkbox2
set(handles.grupo1,'Visible','on');%activar checkbox
guidata(hObject, handles);


% --- Executes on selection change in Menu1.
function Menu1_Callback(hObject, eventdata, handles)
% hObject    handle to Menu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Menu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Menu1
set(hObject,'BackgroundColor','white');
axes(handles.Imagen2);
axis off; %desabilitar ejes coordenados
opcion=get(handles.Menu1,'value');%leer opcion del menu
handles.sigmain=str2double(get(handles.sigma,'String'))
set(handles.Menu2,'enable','on');%habilitar menu2
cla(handles.Imagen3,'reset')%limpiar imagen en axis3
set(handles.grupo2,'Visible','off');%ocultar opcion para filtro
set(handles.Guardar,'Visible','off');%Desactivar boton guardar boton para guardar

switch opcion
    case 1
        %ruido otiginal, color o escala de grises
        handles.Ifiltro=handles.Ioriginal;
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2);
        axis off; %desabilitar ejes coordenados;
    case 2
        %ruido gaussiano
        handles.Ifiltro=handles.Ioriginal;
        %aplicar ruido gaussiano
        handles.Ifiltro = imnoise((handles.Ifiltro),'gaussian',0,handles.sigmain);%
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;
    case 3
        %ruido sal y pimienta
        handles.Ifiltro=handles.Ioriginal;
        %aplicar ruido sal y pimienta
        handles.Ifiltro = imnoise((handles.Ifiltro), 'salt & pepper',handles.sigmain);%
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;
    case 4
        %ruido poisson
        handles.Ifiltro=handles.Ioriginal;
        %aplicar poisson
        handles.Ifiltro = imnoise((handles.Ifiltro), 'poisson');%
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;
    case 5
        %ruido multiplicativo
        handles.Ifiltro=handles.Ioriginal;
        %aplicar multiplicativo
        handles.Ifiltro = imnoise((handles.Ifiltro), 'speckle',handles.sigmain);%
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;;
        
    case 6
        %ruido blurring
        handles.Ifiltro=handles.Ioriginal;
        hsize=[5 5]; sigma=5/3;
        PSF = fspecial('gaussian', hsize, sigma);
        handles.Ifiltro=imfilter( handles.Ifiltro,PSF,'conv','same','symmetric');
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;;
        
    case 7
        %ruido blurring+ruido
        handles.Ifiltro=handles.Ioriginal;
        hsize=[5 5]; sigma=5/3;
        PSF = fspecial('gaussian', hsize, sigma);
        handles.Ifiltro=imfilter( handles.Ifiltro,PSF,'conv','same','symmetric');
        handles.Ifiltro = imnoise(uint8(handles.Ifiltro),'gaussian',0,0.002)%ruido al blurring
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;;
    case 8
        handles.Ifiltro=handles.Ioriginal;
        handles.Ifiltro(:,:,1)=handles.Ifiltro(:,:,1);
        handles.Ifiltro(:,:,2)=0;
        handles.Ifiltro(:,:,3)=0;
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;;
    case 9
        handles.Ifiltro=handles.Ioriginal;
        handles.Ifiltro(:,:,1)=0;
        handles.Ifiltro(:,:,2)=handles.Ifiltro(:,:,2);
        handles.Ifiltro(:,:,3)=0;
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;;
    case 10
        handles.Ifiltro=handles.Ioriginal;
        handles.Ifiltro(:,:,1)=0;
        handles.Ifiltro(:,:,2)=0;
        handles.Ifiltro(:,:,3)=handles.Ifiltro(:,:,3);
        imagesc(handles.Ifiltro, 'Parent', handles.Imagen2),colormap('gray');
        axis off; %desabilitar ejes coordenados;;
        
        
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Menu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
end



function sigma_Callback(hObject, eventdata, handles)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma as text
%        str2double(get(hObject,'String')) returns contents of sigma as a double


% --- Executes during object creation, after setting all properties.
function sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Menu2.
function Menu2_Callback(hObject, eventdata, handles)
% hObject    handle to Menu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Menu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Menu2
set(hObject,'BackgroundColor','white');
axes(handles.Imagen3);
axis off; %desabilitar ejes coordenados
handles.sigmain=str2double(get(handles.sigma,'String'));
opcion=get(handles.Menu2,'value');%leer opcion del menu2
set(handles.Guardar,'Visible','on');%activar boton para guardar
set(handles.Guardar1,'Visible','on');%activar boton para guardar
estado1 = get(handles.checkbox2,'Value');%seleccion escala de grises
estado2 = get(handles.checkbox1,'Value');%seleccion imagen en color

%opciones para dejar visible variables para filtro 
set(handles.grupo2,'Visible','off');%dejar invisible grupo  variables filtro
set(handles.Beta_text,'Visible','on');
set(handles.Beta,'Visible','on');
set(handles.text3,'Visible','on');
set(handles.text5,'Visible','on');
set(handles.text4,'Visible','on');
set(handles.Beta,'Visible','on');
set(handles.Hsize,'Visible','on');
set(handles.Sigma2,'Visible','on');
set(handles.Iteraciones,'Visible','on');

set(handles.text8,'Visible','off');
set(handles.text7,'Visible','off');
set(handles.sigma_d,'Visible','off');
set(handles.sigma_r,'Visible','off');
if estado1==1
    switch opcion
        case 1
            %filtro de la mediana
            handles.Ifiltrada=medfilt2(handles.Ifiltro,[3 3]);
            imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3),colormap('gray'),title('Filtro de la Mediana');
            axis off; %desabilitar ejes coordenados
        case 2
            %deteccion de borders en escala de grises (verticales + horizontales)
            sf=fspecial('sobel');
            sc=sf';
            b1=imfilter(handles.Ifiltro,sf);
            b2=imfilter(handles.Ifiltro,sc);
            handles.Ifiltrada=imadd(b1,b2);
            imagesc( handles.Ifiltrada, 'Parent', handles.Imagen3),colormap('gray');
            axis off; %desabilitar ejes coordenados;;
        case 3
            %deconvolucion richardson-lucy
            set(handles.Beta_text,'Visible','off');
            set(handles.Beta,'Visible','off');
            set(handles.grupo2,'Visible','on');
            set(handles.Hsize,'String',5);
            set(handles.Sigma2,'String',5/3);
            set(handles.Iteraciones,'String',20);
            
            
        case 4
            %Landweber
            set(handles.grupo2,'Visible','on');
            set(handles.Beta_text,'Visible','on');
            set(handles.Beta,'Visible','on');
            set(handles.Hsize,'String',5);
            set(handles.Sigma2,'String',5/3);
            set(handles.Iteraciones,'String',10);
            set(handles.Beta,'String',1);
        case 5
            %VanCittert
            set(handles.grupo2,'Visible','on');
            set(handles.Beta_text,'Visible','on');
            set(handles.Beta,'Visible','on');
            set(handles.Hsize,'String',5);
            set(handles.Sigma2,'String',5/3);
            set(handles.Iteraciones,'String',2);
            set(handles.Beta,'String',1);
        case 6
            %filtro bilateral
            set(handles.grupo2,'Visible','on');
            set(handles.Beta_text,'Visible','off');
            set(handles.Beta,'Visible','off');
            set(handles.text3,'Visible','off');
            set(handles.text5,'Visible','off');
            set(handles.text4,'Visible','off');
            set(handles.Beta,'Visible','off');
            set(handles.Hsize,'Visible','off');
            set(handles.Sigma2,'Visible','off');
            set(handles.Iteraciones,'Visible','off');
            
            set(handles.text8,'Visible','on');
            set(handles.text7,'Visible','on');
            set(handles.sigma_d,'Visible','on');
            set(handles.sigma_r,'Visible','on');
            set(handles.sigma_d,'String',3);
            set(handles.sigma_r,'String',40);
        case 7
            %erosion
            se=ones(3,3);%elemento estructurante
            handles.Ifiltrada=imerode(handles.Ifiltro,se);
            imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3),colormap('gray'),title('Erosion');
            axis off; %desabilitar ejes coordenados
        case 8
            %dilatacion
            se=ones(3,3);%elemento estructurante
            handles.Ifiltrada=imdilate(handles.Ifiltro,se);
            imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3),colormap('gray'),title('Dilatacion');
            axis off; %desabilitar ejes coordenados
        case 9
            %efecto cartoon
            %valores por defecto
            mask_radius=20;
            threshold=1;
            ramp=0.3;
            handles.Ifiltrada=cartoon(handles.Ifiltro,mask_radius,threshold,ramp);
            imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3),colormap('gray'),title('Efecto Cartoon');
            axis off; %desabilitar ejes coordenados
    end
end
if estado2==1
    switch opcion
        case 1
            %efecto cartoon
            %valores por defecto
            mask_radius=20;
            threshold=1;
            ramp=0.3;
            handles.Ifiltrada=cartoon(handles.Ifiltro,mask_radius,threshold,ramp);
            imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3),colormap('gray'),title('Efecto Cartoon');
            axis off; %desabilitar ejes coordenados
        case 2 
            %Erosion Color
            %Creamos elemento Estructurante
             se=ones(4,4);
            handles.Ifiltrada=ErosionColor(handles.Ifiltro,se);
            imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3),title('Erosi�n');
            axis off; %desabilitar ejes coordenados
        case 3 
            %Erosion Color
            %Creamos elemento Estructurante
            se=ones(4,4);
            handles.Ifiltrada=DilatacionColor(handles.Ifiltro,se);
            imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3),title('Dilatacion');
            axis off; %desabilitar ejes coordenados
        case 4
            %filtro bilateral
            set(handles.grupo2,'Visible','on');
            set(handles.Beta_text,'Visible','off');
            set(handles.Beta,'Visible','off');
            set(handles.text3,'Visible','off');
            set(handles.text5,'Visible','off');
            set(handles.text4,'Visible','off');
            set(handles.Beta,'Visible','off');
            set(handles.Hsize,'Visible','off');
            set(handles.Sigma2,'Visible','off');
            set(handles.Iteraciones,'Visible','off');
            
            set(handles.text8,'Visible','on');
            set(handles.text7,'Visible','on');
            set(handles.sigma_d,'Visible','on');
            set(handles.sigma_r,'Visible','on');
            set(handles.sigma_d,'String',3);
            set(handles.sigma_r,'String',40);
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Menu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Guardar.
function Guardar_Callback(hObject, eventdata, handles)
% hObject    handle to Guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ifiltrada = handles.Ifiltrada;
filename1 = handles.filename1;
filename1_1 = strrep(filename1, '.jpg','')
% disp(filename1_1);
filtro = get(handles.Menu2,'String')
nom_filtro=filtro{get(handles.Menu2,'Value')}
imwrite(Ifiltrada, strcat(filename1_1,'_',nom_filtro,'.jpg'));

guidata(hObject, handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1

set(handles.Guardar,'Visible','off');%Desactivar boton guardar boton para guardar
set(handles.Guardar1,'Visible','off');%Desactivar boton guardar boton para guardar menu
set(handles.Menu1,'enable','on');%habilitar menu1
set(handles.grupo2,'Visible','off');%ocultar opcion para filtro
estado = get(handles.checkbox1,'Value');

if estado==1
    set(handles.checkbox2,'Value',0);
end
set(handles.Menu2,'String',{'Cartoon','Erosi�n','Dilataci�n','Filtro Bilateral'});%filtros para imagen a color
% imagen en color
handles.Ioriginal=(handles.I);
imagesc(handles.Ioriginal, 'Parent', handles.Imagen2),colormap('gray');
axes(handles.Imagen2);
axis off; %desabilitar ejes coordenados
set(handles.Menu2,'enable','off');%habilitar menu2
cla(handles.Imagen3,'reset')%limpiar imagen en axis3
guidata(hObject, handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox2

set(handles.Guardar,'Visible','off');%Desactivar boton guardar boton para guardar
set(handles.Guardar1,'Visible','off');%Desactivar boton guardar boton para guardar menu
set(handles.Menu1,'enable','on');%habilitar menu1
set(handles.grupo2,'Visible','off');%ocultar opcion para filtro

estado = get(handles.checkbox2,'Value');
if estado==1
    set(handles.checkbox1,'Value',0);
end
set(handles.Menu2,'String',{'Filtro de la Mediana','Deteccion de Bordes','Richardson-lucy','Landweber','VanCitter','Filtro Bilateral','Erosion','Dilatacion','Cartoon'});%seteamos valores filtros escala de grises
%convertir imagen en escala de grises
handles.Ioriginal=rgb2gray(handles.I);
imagesc(handles.Ioriginal, 'Parent', handles.Imagen2),colormap('gray');
axes(handles.Imagen2);
axis off; %desabilitar ejes coordenados
set(handles.Menu2,'enable','off');%habilitar menu2
cla(handles.Imagen3,'reset')%limpiar imagen en axis3
guidata(hObject, handles);



function Hsize_Callback(hObject, eventdata, handles)
% hObject    handle to Hsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Hsize as text
%        str2double(get(hObject,'String')) returns contents of Hsize as a double


% --- Executes during object creation, after setting all properties.
function Hsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Hsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Iteraciones_Callback(hObject, eventdata, handles)
% hObject    handle to Iteraciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Iteraciones as text
%        str2double(get(hObject,'String')) returns contents of Iteraciones as a double


% --- Executes during object creation, after setting all properties.
function Iteraciones_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Iteraciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Aceptar.
function Aceptar_Callback(hObject, eventdata, handles)
% hObject    handle to Aceptar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Imagen3);
axis off; %desabilitar ejes coordenados


if(get(handles.Menu2,'Value')==3)%ver si aplico richardson-lucy
    n=str2double(get(handles.Hsize,'String'));
    sigma=str2double(get(handles.Sigma2,'String'));
    hsize=[n n];
    Iteraciones=str2double(get(handles.Iteraciones,'String'));
    PSF = fspecial('gaussian', hsize, sigma);
    handles.Ifiltrada=DeconvRL(handles.Ifiltro,PSF,Iteraciones);
end
if((get(handles.Menu2,'Value')==4)&&(get(handles.checkbox2,'Value')==1))%ver si aplico Landweber
    n=str2double(get(handles.Hsize,'String'));
    sigma=str2double(get(handles.Sigma2,'String'));
    hsize=[n n];
    Iteraciones=str2double(get(handles.Iteraciones,'String'));
    PSF = fspecial('gaussian', hsize, sigma);
    beta=str2double(get(handles.Beta,'String'));
    handles.Ifiltrada=Landweber(handles.Ifiltro,PSF,Iteraciones,beta);
end
if(get(handles.Menu2,'Value')==5)%ver si aplico VanCittert
    n=str2double(get(handles.Hsize,'String'));
    sigma=str2double(get(handles.Sigma2,'String'));
    hsize=[n n];
    Iteraciones=str2double(get(handles.Iteraciones,'String'));
    PSF = fspecial('gaussian', hsize, sigma);
    beta=str2double(get(handles.Beta,'String'));
    handles.Ifiltrada=VanCittert(handles.Ifiltro,PSF,Iteraciones,beta);
end

if(get(handles.Menu2,'Value')==6)%si selecciono filtro Bilateral aplicarlo al aceptar
    sigma_d=str2double(get(handles.sigma_d,'String'));
    sigma_r=str2double(get(handles.sigma_r,'String'));
    handles.Ifiltrada=bilateralFilter(handles.Ifiltro, sigma_d , sigma_r);
    
end
    %para imagen a color
if((get(handles.Menu2,'Value')==4)&&(get(handles.checkbox1,'Value')==1))%ver si aplico filtro bilateral
    sigma_d=str2double(get(handles.sigma_d,'String'));
    sigma_r=str2double(get(handles.sigma_r,'String'));
    warndlg({'Este proceso puede tomar un poco de tiempo','Esperar resultados en Recuadro 3'},'!! Procesando !!')
    handles.Ifiltrada=bilateralFilter(handles.Ifiltro, sigma_d , sigma_r);
end

imagesc(handles.Ifiltrada, 'Parent', handles.Imagen3,[0 255]);
axes(handles.Imagen3);
axis off; %desabilitar ejes coordenados

guidata(hObject, handles);


function Sigma2_Callback(hObject, eventdata, handles)
% hObject    handle to Sigma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sigma2 as text
%        str2double(get(hObject,'String')) returns contents of Sigma2 as a double


% --- Executes during object creation, after setting all properties.
function Sigma2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sigma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Beta_Callback(hObject, eventdata, handles)
% hObject    handle to Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Beta as text
%        str2double(get(hObject,'String')) returns contents of Beta as a double


% --- Executes during object creation, after setting all properties.
function Beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigma_d_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma_d as text
%        str2double(get(hObject,'String')) returns contents of sigma_d as a double


% --- Executes during object creation, after setting all properties.
function sigma_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigma_r_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma_r as text
%        str2double(get(hObject,'String')) returns contents of sigma_r as a double


% --- Executes during object creation, after setting all properties.
function sigma_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Info.
function Info_Callback(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msgbox({'Computaci�n Grafica 2017','Integrantes:', '    Jorge Valdes','    Ignacio Monjes', '    Jorge Urra', 'Ingenieria Civil Informatica'}, 'Informaci�n','info');


% --------------------------------------------------------------------
function Guardar1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Guardar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to Guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ifiltrada = handles.Ifiltrada;
filename1 = handles.filename1;
filename1_1 = strrep(filename1, '.jpg','')
% disp(filename1_1);
filtro = get(handles.Menu2,'String')
nom_filtro=filtro{get(handles.Menu2,'Value')}
imwrite(Ifiltrada, strcat(filename1_1,'_',nom_filtro,'.jpg'));

guidata(hObject, handles);


% --------------------------------------------------------------------
function Abrir_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Abrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile('*.jpg','File Selector'); % Buscar imagen de forma gráfica
fullpathname1 = strcat(pathname, filename);  % Obtener direccion
handles.filename1 = filename;

I= imread(fullpathname1);
handles.I = I;
handles.color_o_gris = size(handles.I,3);%saber si es imagen a color o escala de grises
if(handles.color_o_gris==3)%si es color
    imagesc(handles.I, 'Parent', handles.Imagen1);
     set(handles.checkbox2,'Value',0);
   set(handles.checkbox1,'Value',0);
   set(handles.checkbox2,'enable','on');
   set(handles.checkbox1,'enable','on');
else%es gris
   imagesc(handles.I, 'Parent', handles.Imagen1),colormap(gray);%Cargar Imagen
   handles.Ioriginal=handles.I;
   set(handles.checkbox2,'Value',1);
   set(handles.checkbox1,'Value',0);
   set(handles.checkbox2,'enable','off');
   set(handles.checkbox1,'enable','off');
   set(handles.Menu1,'enable','on');%habilitar menu1
   set(handles.grupo2,'Visible','off');%ocultar opcion para filtro
   set(handles.Menu2,'String',{'Filtro de la Mediana','Deteccion de Bordes','Richardson-lucy','Landweber','VanCitter','Filtro Bilateral','Erosion','Dilatacion','Cartoon'});%seteamos valores filtros escala de grises
   
   
end

axes(handles.Imagen1);
axis off; %desabilitar ejes coordenados
set(handles.sigma, 'String',0.05);
set(handles.checkbox1,'Visible','on');%activar checkbox1
set(handles.checkbox2,'Visible','on');%activar checkbox2
set(handles.grupo1,'Visible','on');%activar checkbox
guidata(hObject, handles);
