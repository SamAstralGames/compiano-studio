import  'package:flutter/material.dart' ; 

class  SizeMeasureWidget  extends  StatefulWidget  { 
  final Widget child; 
  final ValueChanged<Size> onSizeMeasured; 

  const SizeMeasureWidget({ 
    Key? key, 
    required  this.onSizeMeasured , 
    required  this.child , 
  }) : super (key: key); 

  @override
   _SizeMeasureWidgetState createState() => _SizeMeasureWidgetState(); 
} 

class  _SizeMeasureWidgetState  extends  State <SizeMeasureWidget> { 
  final GlobalKey _sizeKey = GlobalKey(); 

  @override
   Widget build(BuildContext context) { 
    return Container( 
      key: _sizeKey, 
      child: widget.child, 
    ); 
  } @override 

  void 
  initState () { 
    super.initState (); 
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      RenderBox renderBox = _sizeKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size; 
      widget.onSizeMeasured(size);
      //_getSize(); 
    });// void _getSize() {     RenderBox renderBox = _sizeKey.currentContext!.findRenderObject() as RenderBox;     Size size = renderBox.size; widget.onSizeMeasured     (size);   } 
  }

}