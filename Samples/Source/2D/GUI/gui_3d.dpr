{$I terra.inc}
{$IFDEF MOBILE}Library{$ELSE}Program{$ENDIF} MaterialDemo;

uses
  MemCheck,
  TERRA_Object,
  TERRA_MemoryManager,
  TERRA_Application,
  TERRA_DemoApplication,
  TERRA_Engine,
  TERRA_Utils,
  TERRA_ResourceManager,
  TERRA_GraphicsManager,
  TERRA_OS,
  TERRA_Math,
  TERRA_Vector2D,
  TERRA_Vector3D,
  TERRA_Font,
  TERRA_Texture,
  TERRA_FileManager,
  TERRA_InputManager,
  TERRA_Collections,
  TERRA_Viewport,
  TERRA_Mesh,
  TERRA_Color,
  TERRA_String,
  TERRA_ScreenFX,
  TERRA_Matrix4x4,
  TERRA_UIView,
  TERRA_UIPerspectiveView,
  TERRA_UIWidget,
  TERRA_UITemplates,
  TERRA_UIImage,
  TERRA_UITiledRect,
  TERRA_UIDimension;

Type
  MyDemo = Class(DemoApplication)
    Public
			Procedure OnCreate; Override;
      Procedure OnDestroy; Override;
      Procedure OnRender2D(V: TERRAViewport); Override;
      Procedure OnRender3D(V: TERRAViewport); Override;
  End;


  DemoUIController = Class(UIController)
    Public
      Constructor Create();

      Procedure OnMyButtonClick(Src:UIWidget);
  End;

Var
  Solid:MeshInstance;
  DiffuseTex:TERRATexture;

  MyUI:UIView;
  MyUIProxy:UIPerspectiveView;

  MyWnd, MyBtn:UIWidget;
  MyController:UIController;

Procedure MyDemo.OnCreate;
Begin
  Inherited;

  // enable demo floor
  Self.Floor.SetPosition(Vector3D_Zero);
  Self.MainViewport.Visible := True;

  UITemplates.AddTemplate(UIWindowTemplate.Create('wnd_template', Engine.Textures.GetItem('ui_window'), 45, 28, 147, 98));
  UITemplates.AddTemplate(UIButtonTemplate.Create('btn_template', Engine.Textures.GetItem('ui_button2'), 25, 10, 220, 37));

  MyController := DemoUIController.Create();

  MyUI := UIView.Create('demo3dgui', UIPixels(960), UIPixels(640));
  MyUI.Viewport.BackgroundColor := ColorBlue;
  MyUI.Viewport.AutoResolve := True;
  MyUI.Viewport.FXChain.AddEffect(VignetteFX.Create());

  MyUIProxy := UIPerspectiveView.Create('proxy', MyUI);
  MyUIProxy.SetScale(Vector3D_Constant(4));
  MyUIProxy.SetPosition(Vector3D_Create(0, 4, -4.1));
  MyUIProxy.SetRotation(Vector3D_Create(-90*RAD, 0, 0));

  MyWnd := UIInstancedWidget.Create('mywnd', MyUI, 0, 0, 10, UIPixels(643), UIPixels(231), 'wnd_template');
  MyWnd.Draggable := True;
  MyWnd.Align := waCenter;
  MyWnd.Controller := MyController;

  MyBtn := UIInstancedWidget.Create('mybtn', MyWnd, 0, 0, 1, UIPixels(250), UIPixels(50), 'btn_template');
  MyBtn.Align := waCenter;
  MyBtn.Controller := MyController;
//  MyBtn.SetPropertyValue('caption', 'custom caption!');

  DiffuseTex := Engine.Textures.GetItem('metal_diffuse');
  Solid := MeshInstance.Create(Engine.Meshes.CubeMesh);
  Solid.SetDiffuseMap(0, DiffuseTex);
  Solid.SetPosition(Vector3D_Create(0, 4, 0));
  Solid.SetScale(Vector3D_Constant(8.0));
End;

Procedure MyDemo.OnDestroy;
Begin
  ReleaseObject(Solid);

  Inherited;
End;

Procedure MyDemo.OnRender2D(V: TERRAViewport);
Begin
  Engine.Graphics.AddRenderable(V, MyUI);

  Inherited;
End;

Procedure MyDemo.OnRender3D(V: TERRAViewport);
Begin
  Inherited;
  Engine.Graphics.AddRenderable(V, Solid);
  Engine.Graphics.AddRenderable(V, MyUIProxy);
End;

// GUI event handlers
// All event handlers must be procedures that receive a Widget as argument
// The Widget argument provides the widget that called this event handler
Constructor DemoUIController.Create;
Begin
  Self._ObjectName := 'demo';
  SetHandler(widgetEvent_MouseDown, OnMyButtonClick); // Assign a onClick event handler
End;

Procedure DemoUIController.OnMyButtonClick(Src:UIWidget);
Begin
 // MyUI.MessageBox('You clicked the button!');
End;


{$IFDEF IPHONE}
Procedure StartGame; cdecl; export;
{$ENDIF}
Begin
  MyDemo.Create();
{$IFDEF IPHONE}
End;
{$ENDIF}

End.

