import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'date_functions.dart';
import 'hijri_calendar_config.dart';
import 'hijri_date.dart';

class HijriViewModel {
  ///adjustment value for hijri calendar
  int adjustmentValue = 0;

  /// islamic event
  final List<Map<String, dynamic>> islamicEvents = [
    {'name': 'Miladu Annabiyy','hijriMonth': 3, 'hijriDay': 12,"arabic_name":"ميلاد النبي صلى الله عليه وسلم" },
    {'name': 'Eid-ul-Fitr', 'hijriMonth': 10, 'hijriDay': 1,"arabic_name":"عيد الفطر"},
    {'name': 'Hajj Starting', 'hijriMonth': 12, 'hijriDay': 8,"arabic_name":"ليلة التروية"},
    {'name': 'Arafa Day', 'hijriMonth': 12, 'hijriDay': 9,"arabic_name":"يوم عرفة"},
    {'name': 'Eid-ul-Adha', 'hijriMonth': 12, 'hijriDay': 10,"arabic_name":"عيد الأضحى"},
    {'name': 'Aashoraa Day', 'hijriMonth': 1, 'hijriDay': 10,"arabic_name":"يوم عاشوراء"},
    {'name': 'Ramadan Start', 'hijriMonth': 9, 'hijriDay': 1,"arabic_name":"هلال رمضان"},
    {'name': 'Lailat-ul-Qadr Start', 'hijriMonth': 9, 'hijriDay': 20,"arabic_name":"ليلة القدر"},
    {'name': 'Night of Mid Shaban', 'hijriMonth': 8, 'hijriDay': 15,"arabic_name":"ليلة النصف من شعبان"},
    {'name': 'Badr Battle', 'hijriMonth': 9, 'hijriDay': 17,"arabic_name":"معركة بدر"},
    {'name': 'Israa and Miraj', 'hijriMonth': 7, 'hijriDay': 27,"arabic_name":"الإسراء والمعراج"},
  ];


  ///each day header value
  var headerOfDay = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  var showOfDay = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  ///below date variables to manage highlight, disable, selected date ui
  DateTime currentDisplayMonthYear = DateTime.now();
  DateTime selectedDate = DateTime.now();
  DateTime todayDate = DateTime.now();

  ///this function is used to set each day block
  Widget getDate({
    required bool isHijriView,
    required double fontSize,
    required DateTime day,
    required Color highlightBorder,
    Color? backgroundColor,
    required deActiveDateBorderColor,
    TextStyle? style,
    double? borderRadius,
    required Color defaultTextColor,
    required Color defaultBorder,
    required Color highlightTextColor,
    Function(DateTime selectedDate)? onSelectedEnglishDate,
    Function(HijriDate selectedDate)? onSelectedHijriDate,
    required bool isDisablePreviousNextMonthDates,
  }) {
    bool isCurrentMonthDays = day.month == currentDisplayMonthYear.month;

    var hijridate = !adjustmentValue.isNegative
        ? HijriCalendarConfig.fromDate(DateTime(day.year, day.month, day.day)
            .add(Duration(days: adjustmentValue)))
        : HijriCalendarConfig.fromDate(DateTime(day.year, day.month, day.day)
            .subtract(Duration(days: adjustmentValue.abs())));

    return GestureDetector(
      onTap: () {
        if (!isCurrentMonthDays) {
          currentDisplayMonthYear = day;
        }
        selectedDate = day;
        onSelectedEnglishDate!(DateTime(day.year, day.month, day.day));
        onSelectedHijriDate!(HijriDate(
            year: DateFunctions.convertEnglishToHijriNumber(hijridate.hYear),
            month: DateFunctions.convertEnglishToHijriNumber(hijridate.hMonth),
            day: DateFunctions.convertEnglishToHijriNumber(hijridate.hDay)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: day.year == todayDate.year &&
                  day.month == todayDate.month &&
                  day.day == DateTime.now().day
              ? highlightBorder
              : backgroundColor,
          border: Border.all(

              /// set border color
              color: day.year == todayDate.year &&
                      day.month == todayDate.month &&
                      day.day == todayDate.day
                  ? highlightBorder
                  : selectedDate.year == day.year &&
                          selectedDate.month == day.month &&
                          selectedDate.day == day.day
                      ? highlightBorder
                      : deActiveDateBorderColor,

              ///set border width
              width: day.year == todayDate.year &&
                      day.month == todayDate.month &&
                      day.day == todayDate.day
                  ? 0
                  : selectedDate.year == day.year &&
                          selectedDate.month == day.month &&
                          selectedDate.day == day.day
                      ? 2
                      : 0),
         shape: BoxShape.circle
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            !isHijriView
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      DateFunctions.convertEnglishToHijriNumber(hijridate.hDay)
                          .toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: day.year == todayDate.year &&
                              day.month == todayDate.month &&
                              day.day == todayDate.day
                          ? style?.copyWith(
                                  fontSize: fontSize,
                                  color: highlightTextColor) ??
                              TextStyle(
                                  fontSize: fontSize, color: highlightTextColor)
                          : style?.copyWith(
                                  fontSize: fontSize,
                                  color: !isCurrentMonthDays
                                      ? (isDisablePreviousNextMonthDates
                                          ? defaultTextColor.withOpacity(.1)
                                          : defaultTextColor)
                                      : defaultTextColor) ??
                              TextStyle(
                                fontSize: fontSize,
                              ),
                    ),
                  ),
            const SizedBox(width: 5,),
            Text(
              day.day.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: day.year == todayDate.year &&
                  day.month == todayDate.month &&
                  day.day == todayDate.day
                  ? style?.copyWith(
                  fontSize: fontSize, color: highlightTextColor) ??
                  TextStyle(fontSize: fontSize, color: highlightTextColor)
                  : style?.copyWith(
                  fontSize: fontSize,
                  color: !isCurrentMonthDays
                      ? (isDisablePreviousNextMonthDates
                      ? defaultTextColor.withOpacity(.1)
                      : defaultTextColor)
                      : defaultTextColor),
            ),
          ],
        ),
      ),
    );
  }

  ///get hijri month year values by passing current displayed month & year
  String getHijriMonthYear(String ? local, {DateTime ? timeNow}) {
    int lastDayOfMonth = DateFunctions.getLastDayOfCurrentMonth(
            currentMonth:timeNow?? currentDisplayMonthYear).day;
    HijriCalendarConfig.setLocal(local??"ar");
    String firstDateMonthName = HijriCalendarConfig.fromDate(DateTime(
        timeNow?.year?? currentDisplayMonthYear.year, timeNow?.month?? currentDisplayMonthYear.month, 1))
        .getLongMonthName();
    String lastDateMonthName = HijriCalendarConfig.fromDate(DateTime(
        timeNow?.year??  currentDisplayMonthYear.year,
        timeNow?.month??    currentDisplayMonthYear.month,
            lastDayOfMonth))
        .getLongMonthName();
    return firstDateMonthName == lastDateMonthName
        ? firstDateMonthName
        : "$firstDateMonthName / $lastDateMonthName";
  }

  ///show previous month
  getPreviousMonth() {
    int year = currentDisplayMonthYear.year;
    int month = currentDisplayMonthYear.month - 1;

    if (month == 0) {
      month = 12;
      year--;
    }

    // Ensure the day is valid for the new month and year
    int day = currentDisplayMonthYear.day;
    int lastDayOfPreviousMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfPreviousMonth) {
      day = lastDayOfPreviousMonth;
    }
    currentDisplayMonthYear = DateTime(year, month, day);
  }

  ///show next month
  getNextMonth() {
    int year = currentDisplayMonthYear.year;
    int month = currentDisplayMonthYear.month + 1;

    if (month == 13) {
      month = 1;
      year++;
    }

    int day = currentDisplayMonthYear.day;
    int lastDayOfNextMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfNextMonth) {
      day = lastDayOfNextMonth;
    }
    currentDisplayMonthYear = DateTime(year, month, day);
  }

  /// get All Islamic event
  List<Map<String, dynamic>> getIslamicEventsForYear(int hijriYear, {int adjustmentValue = 0}) {
    List<Map<String, dynamic>> eventsForYear = [];

    for (var event in islamicEvents) {
      // Create Hijri date for the event
      var hijriDate = HijriCalendarConfig()
        ..hYear = hijriYear
        ..hMonth = event['hijriMonth']
        ..hDay = event['hijriDay'];

      // Convert Hijri date to Gregorian
      DateTime gregorianDate = hijriDate.hijriToGregorian(
        hijriDate.hYear,
        hijriDate.hMonth,
        hijriDate.hDay,
      );

      // Check if the event has already passed
      if (gregorianDate.isBefore(DateTime.now())) {
        // Move the event to the next Hijri year
        hijriDate.hYear = hijriYear + 1;
        gregorianDate = hijriDate.hijriToGregorian(
          hijriDate.hYear,
          hijriDate.hMonth,
          hijriDate.hDay,
        );
      }

      // Apply adjustment using the adjustmentValue
      gregorianDate = adjustmentValue.isNegative
          ? gregorianDate.subtract(Duration(days: adjustmentValue.abs()))
          : gregorianDate.add(Duration(days: adjustmentValue));

      // Convert the adjusted Gregorian date back to Hijri
      var adjustedHijriDate = HijriCalendarConfig.fromDate(gregorianDate.toUtc());

      String dayName = DateFormat('EEEE',"ar").format(gregorianDate); // Use 'en' for English


      // Add the event with adjusted details
      eventsForYear.add({
        'name': event['name'],
        'hijriDate':
        '${adjustedHijriDate.dayWeName}, ${DateFunctions.convertEnglishToHijriNumber(adjustedHijriDate.hDay)} ${adjustedHijriDate.longMonthName} ${DateFunctions.convertEnglishToHijriNumber(adjustedHijriDate.hYear)}',
        'gregorianDate': gregorianDate.toIso8601String(),
        'daysLeft': gregorianDate.difference(DateTime.now()).inDays,
        'arabic_name':event['arabic_name']
      });
    }

    // Sort events by Gregorian date
    eventsForYear.sort((a, b) {
      DateTime dateA = DateTime.parse(a['gregorianDate']);
      DateTime dateB = DateTime.parse(b['gregorianDate']);
      return dateA.compareTo(dateB);
    });

    return eventsForYear;
  }



}
