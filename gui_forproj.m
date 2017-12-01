%gui_forproj desplays pericytes to gather data it saves classification in
%labels.mat

%Matlab files needed:
%find_crop_size
%create_sphere


function varargout = gui_forproj(varargin)
% GUI_FORPROJ MATLAB code for gui_forproj.fig
%      GUI_FORPROJ, by itself, creates a new GUI_FORPROJ or raises the existing
%      singleton*.
%wqeqwe
%      H = GUI_FORPROJ returns the handle to a new GUI_FORPROJ or the handle to
%      the existing singleton*.
%
%      GUI_FORPROJ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FORPROJ.M with the given input arguments.
%
%      GUI_FORPROJ('Property','Value',...) creates a new GUI_FORPROJ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_forproj_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_forproj_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_forproj

% Last Modified by GUIDE v2.5 05-Jul-2017 14:48:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_forproj_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_forproj_OutputFcn, ...
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


% --- Executes just before gui_forproj is made visible.
function gui_forproj_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_forproj (see VARARGIN)

% Choose default command line output for gui_forproj
handles.output = hObject;
global path_for_stack;
%global num_of_seeds;
% if ~exist(path_for_stack)
%     path_for_stack='.';
% end
path_for_stack=uigetdir();

load(sprintf('%s/stack.mat',path_for_stack));
%handles.per_mats=pericytes_mats;
%handles.per_masks=pericytes_bin_mats;
%load num_of_seeds.mat
global labels;
global orginized_out_cc;
global begin_centroids;
global raw_ch1;
global raw_ch3;
%path_for_stack=uigetdir();
if exist(fullfile(path_for_stack, 'labels.mat'), 'file')
    load('labels.mat');
    
else
    labels=zeros(1,orginized_out_cc.NumObjects);
    save labels.mat labels;
end
%global labels=zeros(1,length(handles.per_mats));
set(handles.fitc,'Value',1);
set(handles.pdgfr,'Value',1);
set(handles.mask_checkbox,'Value',1);
set(handles.centroid,'Value',1);
pericyte_slider_Callback(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);
% handles.image1=raw_ch1;
% handles.image3=raw_ch3;

% d1=imadjust(handles.image1(:,:,1));
% d2=imadjust(handles.image3(:,:,1));
% c=cast(zeros([size(d1) 3]),'uint16');
% c(:,:,1)=d1;
% c(:,:,2)=d2;
% UIWAIT makes gui_forproj wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_forproj_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function stack_slider_Callback(hObject, eventdata, handles)
% hObject    handle to stack_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global crop_coordinates;
stack = int32(get(handles.stack_slider, 'Value'));
% d1=imadjust(handles.image1(:,:,stack));
% d2=imadjust(handles.image3(:,:,stack));
% c=cast(zeros([size(d1) 3]),'uint16');
% c(:,:,1)=d1;
% c(:,:,2)=d2;
%per_num = int32(get(handles.pericyte_slider, 'Value'));
%str=sprintf('seed_%d.mat',per_num);


%handles.image=b;
stack_length=crop_coordinates(5)-crop_coordinates(6)+1;
set(handles.stack_slider,'Max',stack_length );
set(handles.stack_slider, 'SliderStep', [1/stack_length , 10/stack_length ]);
create_image(handles);
% handles.image=c;
% handles.current_data=imshow(handles.image,[]);


% --- Executes during object creation, after setting all properties.
function stack_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stack_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%maxNumberOfImages = size(handles.current_per,3);
set(hObject, 'Min', 1);
set(hObject, 'Max',520);
set(hObject, 'Value', 1);
set(hObject, 'SliderStep', [1/520 , 10/520 ]);


% --- Executes on slider movement.
function pericyte_slider_Callback(hObject, eventdata, handles)
% hObject    handle to pericyte_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global labels;
%global num_of_seeds;
%global mask_image;
global crop_coordinates;
global orginized_out_cc;
global mask_points;
global begin_centroids;
global sphere_pts;
global raw_ch1;
per_num = int32(get(handles.pericyte_slider, 'Value'));
if per_num>0 && per_num<length(labels) && labels(per_num)~=0
    asd=find(labels==0);
    if ~isempty(asd)
        per_num=asd(1);
    else
        h = errordlg('all stack pericytes are labeled please choose a different stack');
        load_reset_Callback(hObject, eventdata, handles);
    end
end
set(handles.pericyte_slider,'Value',per_num);
% a=handles.per_mats{per_num};
% %handles.current_per=a;
set(handles.stack_slider,'Value',1);
% maxNumberOfImages = size(a,3);
set(handles.pericyte_slider,'Max',orginized_out_cc.NumObjects);
% set(handles.stack_slider,'Max', maxNumberOfImages);
set(handles.pericyte_slider, 'SliderStep', [1/orginized_out_cc.NumObjects , 10/orginized_out_cc.NumObjects ]);
% set(handles.stack_slider, 'SliderStep', [1/maxNumberOfImages , 10/maxNumberOfImages ]);
%% calculate pericyte crop coordinates (seed_location)
[Y,X,Z]=ind2sub(orginized_out_cc.ImageSize,orginized_out_cc.PixelIdxList{per_num});
%[sy,sx,sz]=ind2sub(size(raw_ch1),sphere_pts);
[crop_coordinates(1),crop_coordinates(2)]=find_crop_size(orginized_out_cc.ImageSize(1),Y,100);
[crop_coordinates(3),crop_coordinates(4)]=find_crop_size(orginized_out_cc.ImageSize(2),X,100);
[crop_coordinates(5),crop_coordinates(6)]=find_crop_size(orginized_out_cc.ImageSize(3),Z,0);
currImageSize=[crop_coordinates(1)-crop_coordinates(2)+1,crop_coordinates(3)-crop_coordinates(4)+1,crop_coordinates(5)-crop_coordinates(6)+1];
mask_points=[Y-crop_coordinates(2)+1,X-crop_coordinates(4)+1,Z-crop_coordinates(6)+1];
%sPts=[sy-crop_coordinates(2)+1,sx-crop_coordinates(4)+1,sz-crop_coordinates(6)+1];
sphere_pts=create_sphere(size(raw_ch1),begin_centroids(per_num),5);
%%
%str=sprintf('seed_%d.mat',per_num);
%seed_s=load(str);
%mask_image=false(currImageSize);
%mask_image(croppedY,croppedX,croppedZ)=true;
%seed_image=seed_s.seed_image;
stack_slider_Callback(handles.pericyte_slider, eventdata, handles);
create_image(handles);


% --- Executes during object creation, after setting all properties.
function pericyte_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pericyte_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', 1);
set(hObject, 'Max', 520);
set(hObject, 'Value', 1);
set(hObject, 'SliderStep', [1/520 , 10/520 ]);


% --- Executes on button press in thin_strand.
function thin_strand_Callback(hObject, eventdata, handles)
% hObject    handle to thin_strand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

per_num=int32(get(handles.pericyte_slider,'Value'));
global labels;

labels(per_num)=1;
save_Callback(hObject, eventdata, handles);



% --- Executes on button press in mesh.
function mesh_Callback(hObject, eventdata, handles)
% hObject    handle to mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global labels;

per_num=int32(get(handles.pericyte_slider,'Value'));
labels(per_num)=2;
handles.labels(per_num)=2;
save_Callback(hObject, eventdata, handles);

% --- Executes on button press in helical.
function helical_Callback(hObject, eventdata, handles)
% hObject    handle to helical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
per_num=int32(get(handles.pericyte_slider,'Value'));
global labels;

labels(per_num)=3;
save_Callback(hObject, eventdata, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global labels;
fid = fopen( 'labels.txt', 'wt' );
if -1 == fid
   error('Cant open file.');
end
 
for l = 1:length(labels)
  fprintf( fid, 'seed number %d label is %d\n', l,labels(l));
end
fclose(fid);
save labels.mat labels


% --- Executes on button press in garbage.
function garbage_Callback(hObject, eventdata, handles)
% hObject    handle to garbage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
per_num=int32(get(handles.pericyte_slider,'Value'));
global labels;

labels(per_num)=-1;
save_Callback(hObject, eventdata, handles);


% --- Executes on button press in load_reset.
function load_reset_Callback(hObject, eventdata, handles)
% hObject    handle to load_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path_for_stack;
path_for_stack=uigetdir();
if exist(fullfile(path_for_stack, 'stack.mat'), 'file')
    gui_forproj_OpeningFcn(hObject, eventdata, handles);

else
    h = errordlg('invalid folder please choose a folder containing stack.mat');
end


% --- Executes on button press in fitc.
function fitc_Callback(hObject, eventdata, handles)
% hObject    handle to fitc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
create_image(handles);
    


% --- Executes on button press in pdgfr.
function pdgfr_Callback(hObject, eventdata, handles)
% hObject    handle to pdgfr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pdgfr
create_image(handles);

% --- Executes on button press in mask_checkbox.
function mask_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to mask_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
create_image(handles);

% Hint: get(hObject,'Value') returns toggle state of mask_checkbox
function create_image(handles)
%global mask_image;
global crop_coordinates
global raw_ch1;
global mask_points;
global raw_ch3;
global sphere_pts;
show_fitc=get(handles.fitc,'Value');
show_pdgfr=get(handles.pdgfr,'Value');
show_mask=get(handles.mask_checkbox,'Value');
show_centroid=get(handles.centroid,'Value');
per_num=int32(get(handles.pericyte_slider,'Value'));
slice = int32(get(handles.stack_slider, 'Value'));

%per_im=handles.per_mats{per_num};
per_im_slice=cast(zeros(crop_coordinates(1)-crop_coordinates(2)+1,crop_coordinates(3)-crop_coordinates(4)+1,3),'uint16');
%handles.current_per=a;
if (show_fitc==1)
    per_im_slice(:,:,2)=imadjust(raw_ch3(crop_coordinates(2):crop_coordinates(1),crop_coordinates(4):crop_coordinates(3),slice));
end
if (show_pdgfr==1)
    per_im_slice(:,:,1)=imadjust(raw_ch1(crop_coordinates(2):crop_coordinates(1),crop_coordinates(4):crop_coordinates(3),slice));
end
if (show_mask==1)
    
    aa=mask_points(find(mask_points(:,3)==slice),1:2);
    dd=ones(size(aa,1),1).*3;
    if(~isempty(dd))
        b=sub2ind(size(per_im_slice),aa(:,1),aa(:,2),dd);
        per_im_slice(b)=65000;
    end
end
if (show_centroid==1)
    
    [sy,sx,sz]=ind2sub(size(raw_ch1),sphere_pts);
    sy=sy';sx=sx';sz=sz';
    sPts=[sy-crop_coordinates(2)+1,sx-crop_coordinates(4)+1,sz-crop_coordinates(6)+1];
    aa2=sPts(find(sPts(:,3)==slice),1:2);
    dd2=ones(size(aa2,1),1).*3;
    if(~isempty(dd2) && ~isempty(aa2))
        b2=sub2ind(size(per_im_slice),aa2(:,1),aa2(:,2),dd2);
        per_im_slice(b2)=65000;
    end
    
end
%axis image;
imshow(per_im_slice,[]);
axis image;


% Update handles structure
%guidata(hObject, handles);
% handles.image1=raw_ch1;
% handles.image3=raw_ch3;

% d1=imadjust(handles.image1(:,:,1));
% d2=imadjust(handles.image3(:,:,1));
% c=cast(zeros([size(d1) 3]),'uint16');
% c(:,:,1)=d1;
% c(:,:,2)=d2;
% UIWAIT makes gui_forproj wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Executes on button press in centroid.
function centroid_Callback(hObject, eventdata, handles)
% hObject    handle to centroid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of centroid
create_image(handles);