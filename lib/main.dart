import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:utilizacion_bloc/bloc/persona/persona_bloc.dart';
import 'package:utilizacion_bloc/views/admin_persona_view.dart';
import 'package:utilizacion_bloc/views/ficha_alta_persona_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PersonaBloc()),
      ],
      child: MaterialApp(
        title: 'Utilizacion bloc',
        debugShowCheckedModeBanner: false,
        routes: {
          'lista': (context) => const AdminPersonaView(),
          'alta': (context) => const FichaAltaPersonaView(),
        },
        initialRoute: 'lista',
        builder: (context, child) {
          return Scaffold(
            body: Builder(builder: (context) {
              ///Se utiliza para cargar el listado cuando se levanta la app
              context.read<PersonaBloc>().add(const OnObtenerlstPersona());

              ///Configuracion del responsive_wrapper
              return ResponsiveWrapper.builder(
                  maxWidth: 1200,
                  minWidth: 250,
                  defaultScale: true,
                  breakpoints: [
                    const ResponsiveBreakpoint.autoScale(260, name: PHONE),
                    const ResponsiveBreakpoint.autoScale(500, name: MOBILE),
                    const ResponsiveBreakpoint.autoScale(780, name: TABLET),
                    const ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                    // const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                  ],
                  child);
            }),
          );
        },
        supportedLocales: const [
          Locale('es', 'ES'), // Español,
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
