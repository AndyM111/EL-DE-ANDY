import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inserta cuadrado, triángulo',
            style: TextStyle(color: Colors.white), // Cambio de color del texto en la AppBar
          ),
          centerTitle: true,
          backgroundColor: Colors.green, // Cambio de color de fondo de la AppBar
        ),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _figure = '';
  String _errorMessage = '';
  bool _showFigure = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 10), // Añadido padding horizontal para una sola línea
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Añadido borde redondeado
              color: Colors.white,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _figure = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Escribe aquí',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_figure.toLowerCase() == 'triángulo' || _figure.toLowerCase() == 'cuadrado') {
                _errorMessage = '';
                _showFigure = true; // Mostrar la figura al presionar el botón
              } else {
                _errorMessage = 'No se ingresó correctamente el nombre de la figura';
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Cambio de fondo del botón a rojo
            ),
            child: const Text(
              'Aceptar',
              style: TextStyle(color: Colors.black), // Cambio de color del texto a negro
            ),
          ),
          const SizedBox(height: 10),
          if (_errorMessage.isNotEmpty) // Mostrar mensaje de error si hay un mensaje
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 20),
          if (_showFigure) // Mostrar la figura solo si se presionó el botón
            Column(
              children: [
                CustomPaint(
                  size: Size(300, 300), // Tamaño del área de dibujo
                  painter: _FigurePainter(figure: _figure), // Llamamos al painter con la figura actual
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _figure = '';
                      _showFigure = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Cambio de fondo del botón a rojo
                  ),
                  child: const Text(
                    'Eliminar Figura',
                    style: TextStyle(color: Colors.black), // Cambio de color del texto a negro
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FigurePainter extends CustomPainter {
  final String figure;

  _FigurePainter({required this.figure});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow // Cambio de color de la figura
      ..strokeWidth = 2
      ..style = PaintingStyle.fill; // Cambio de estilo de dibujo a fill para que la figura se llene completamente

    final center = Offset(size.width / 2, size.height / 2);

    switch (figure.toLowerCase()) {
      case 'triángulo':
        _drawTriangle(canvas, paint, center, size.width / 3);
        break;
      case 'cuadrado':
        _drawSquare(canvas, paint, center, size.width / 3);
        break;
      default:
        _drawText(canvas, paint, center, 'La figura no fue encontrada');
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawTriangle(Canvas canvas, Paint paint, Offset center, double side) {
    final path = Path();
    path.moveTo(center.dx, center.dy - side / 2);
    path.lineTo(center.dx + side / 2, center.dy + side / 2);
    path.lineTo(center.dx - side / 2, center.dy + side / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSquare(Canvas canvas, Paint paint, Offset center, double side) {
    final rect = Rect.fromCenter(center: center, width: side, height: side);
    canvas.drawRect(rect, paint);
  }

  void _drawText(Canvas canvas, Paint paint, Offset center, String text) {
    final textStyle = TextStyle(
      color: const Color.fromARGB(255, 172, 26, 26),
      fontSize: 16,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    final textOffset = Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
  }
}
