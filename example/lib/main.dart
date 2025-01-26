import 'package:flutter/material.dart';
import 'package:islamic_hijri_calendar/islamic_hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Hijri Calendar',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const HijriCalendarExample(),
    );
  }
}

class HijriCalendarExample extends StatefulWidget {
  const HijriCalendarExample({
    super.key,
  });

  @override
  State<HijriCalendarExample> createState() => _HijriCalendarExampleState();
}

class _HijriCalendarExampleState extends State<HijriCalendarExample> {
  HijriViewModel viewmodel = HijriViewModel();

  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>>  events=<Map<String, dynamic>>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      viewmodel.adjustmentValue = 6;
    });

    events  = viewmodel.getIslamicEventsForYear(HijriCalendarConfig.fromDate(viewmodel.selectedDate).hYear,adjustmentValue:viewmodel.adjustmentValue );
    //
    // // Print events

  }
  @override
  Widget build(BuildContext context) {
    HijriCalendarConfig.setLocal("en");

    return Scaffold(
      // appBar: AppBar(elevation: 1, title: const Text("Islamic Hijri Calendar")),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          image: const DecorationImage(image: AssetImage("assets/assets_1.png"),fit: BoxFit.cover),
        ),
        child: SafeArea(

          child: Column(

            children: [

            Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 10,left: 20,right: 20,top: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration:  BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${HijriCalendarConfig.fromDate(viewmodel.selectedDate).hDay} ${HijriCalendarConfig.fromDate(viewmodel.selectedDate).longMonthName} ${HijriCalendarConfig.fromDate(viewmodel.selectedDate).hYear}",
                          textAlign: TextAlign.center,
                          style:const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22, color: Colors.white),
                        ),
                        Text(
                          " ${DateFormat('MMM dd, yyyy')
                              .format(viewmodel.selectedDate)  } ",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white),
                        ),

                      ],
                    ),
                  ),
              Container(
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(10),
               ),
                // height: 450,
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.only(left: 20,right: 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: IslamicHijriCalendar(
                    isHijriView:
                        true, //allowing users to set either the English calendar only or display the Hijri calendar alongside the English calendar
                    highlightBorder:Colors.green,// Set selected date border color
                    defaultBorder: Colors.transparent, // Set default date border color
                    highlightTextColor: Colors.white, // Set today date text color
                    defaultTextColor: Colors.black, //Set others dates text color
                    defaultBackColor: Colors.transparent, // Set default date background color
                    adjustmentValue:
                    viewmodel.adjustmentValue, // Set hijri calendar adjustment value which is set  by user side
                    isGoogleFont:
                        true, // Set it true if you want to use google fonts else false
                    fontFamilyName:
                        "Lato", // Set your custom font family name or google font name
                    getSelectedEnglishDate:
                        (c) {
                      setState(() {
                        viewmodel. selectedDate=c;
                      });


                      print(selectedDate);

                        }, // returns the date selected by user
                    getSelectedHijriDate:
                        (selectedDate) {}, // returns the date selected by user in Hijri format
                    isDisablePreviousNextMonthDates:
                        true, // Set dates which are not included in current month should show disabled or enabled
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(

                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return IslamicEventTile(
                      name: event['name'],
                      hijriDate: event['hijriDate'],
                      gregorianDate: event['gregorianDate'],
                      daysLeft: event['daysLeft'],
                      isHighlighted: event['daysLeft'] == 0, // Highlight the first event
                      onNotificationTap: () {
                        // Notification logic
                        print('${event['name']} notification clicked');
                      }, arabicName:event['arabic_name'],
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );

  }

}




class IslamicEventTile extends StatelessWidget {
  final String name; // Event name
  final String arabicName; // Event name
  final String hijriDate; // Hijri date
  final String gregorianDate; // Gregorian date
  final int daysLeft; // Days left for the event
  final bool isHighlighted; // Highlighted tile
  final VoidCallback onNotificationTap; // Notification tap callback

  IslamicEventTile({
    required this.name,
    required this.hijriDate,
    required this.gregorianDate,
    required this.daysLeft,
    required this.isHighlighted,
    required this.onNotificationTap, required this.arabicName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20,bottom: 8),
      padding: const EdgeInsets.only(left: 20,bottom: 8,right: 20,top: 8),
      decoration: BoxDecoration(
        color:
        // isHighlighted ?
        Colors.white ,
            // : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.0),
        border: isHighlighted
            ? Border.all(color: Colors.blue, width: 2.0)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Name and Notification Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              Text(
                arabicName,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),


            ],
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
            children: [
              // Hijri Date
              Text(
                hijriDate,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                  fontFamily: 'Noor',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Gregorian Date
              Text(
                DateFormat("MMM dd,yyyy").format(DateTime.parse(gregorianDate)) ,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),



          // Days Left
          Text(
            daysLeft > 0
                ? '$daysLeft days left'
                : daysLeft == 0
                ? 'Today'
                : '${daysLeft.abs()} days ago',
            style: TextStyle(
              fontSize: 14.0,
              color: daysLeft > 0 ? Colors.blue : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

