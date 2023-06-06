import 'package:expanse_management/data/Money.dart';

List<Money> geter() {
  Money upwork = Money();
  upwork.name = 'upwork';
  upwork.amount = '650';
  upwork.time = 'today';
  upwork.image = 'Transfer.png';
  upwork.isExpanse = false;
  Money starbucks = Money();
  starbucks.amount = '15';
  starbucks.isExpanse = true;
  starbucks.image = 'Food.png';
  starbucks.name = 'starbucks';
  starbucks.time = 'today';
  Money trasfer = Money();
  trasfer.amount = '100';
  trasfer.isExpanse = true;
  trasfer.image = 'Transportation.png';
  trasfer.name = 'trasfer for sam';
  trasfer.time = 'jan 30,2022';
  return [upwork, starbucks, trasfer, upwork, starbucks, trasfer];
}
