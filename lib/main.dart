import 'linker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lgsy Picker Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: kDefaultColor,
            brightness: Brightness.dark,
          )),
      home: const LandScreen(),
    );
  }
}

class LandScreen extends StatelessWidget {
  const LandScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Container(
              width: context.width() * 0.7,
              height: 50,
              decoration: const BoxDecoration(
                  color: kDefaultColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: CustomWidget.text5(
                  'Pick Media',
                  color: kWhiteColor,
                  fontSize: 17,
                ),
              )),
          onTap: () {
            const MediaPicker()
                .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          },
        ),
      ),
    );
  }
}
