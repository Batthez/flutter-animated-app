import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Intro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LogoApp(),

    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    //mapera o valor de 0 a 1 que vai demorar 2 segundos
    controller = AnimationController(
        vsync: this,
      duration: Duration(seconds: 2),
    );


    // curve = curva da animação
    // alterando a curva, altera drasticamente o modo com que a animação se comporta
    // Cuidado com a curva, porque nem sempre a opacidade vai de 0 até 1, as vezes pula
    // pra cima ou pra baixo
    //Pra ajeitar isso, ir na opacidade e dar um .clamp passando um limite superior e limite superior(0.0 e 1.0)
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut)
      ..addStatusListener((status) {
        //completed = Animação completa
        if(status == AnimationStatus.completed){
          controller.reverse();
        }//dismissed = quando volta a animação e chega no 0 novamente
        else if(status == AnimationStatus.dismissed){
          controller.forward();
        }
      });


    //Animar para frente (pra animar pra trás é so usar controller.reverse()
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GrowTransition(
          child: LogoWidget(),
          animation: animation,
        ),
      ],
    );
  }
}



/*
class AnimatedLogo extends AnimatedWidget{

  AnimatedLogo(Animation<double> animation) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {

    final Animation<double> animation = listenable;

    return Center(
      //Pegar o valor de 0 a 300 com o animation.value
      child: Container(
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }

}*/

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

//Widget que aplica animações
//Pode passar a animação e widget que quiser
//que ele vai cuidar de realizar as animações.
class GrowTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;

  //Pra gerar curva de animação de 0 a 300 ou de 0.1 até 1
  //Tween mapeia o inicio e o fim da animação
  //varia de 0 a 300 dentro de 2 segundos (setados no controller acima)
  // quando o valor for 0, no Tween é 0, quando for 1, no tween é 300
  //Listener que vai chamar a função sempre que tiver uma alteração de valor da animação
  final sizeTween = Tween<double>(begin: 2, end: 300);
  final opacityTween =  Tween<double>(begin: 0.1, end: 1);

  GrowTransition({this.child, this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context,widget){
          return Opacity(
            opacity: opacityTween.evaluate(animation).clamp(0.0, 1.0),
            child: Container(
              height: sizeTween.evaluate(animation) < 0? 0 : sizeTween.evaluate(animation),
              width: sizeTween.evaluate(animation) < 0? 0 : sizeTween.evaluate(animation),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}













