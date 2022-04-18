class Floors {
  static List<String> floorsList = [
    'الدور الارضي',
    'الدور الاول',
    'الدور الثاني',
    'الدور الثالث',
    'الدور الرابع',
    'الدور الخامس',
    'دور اعلى',
    'متجر',
    'مستودع',
  ];

}

class CancelRideReasons {
  static List<String> reasons = [
    'عدم استجابة العميل',
    'حدث معي عطل في مركبة',
    'عدم احترام العميل',
    'بعد المسافة',
    'سوء فهم لطلب العميل',
    'سبب شخصي',
  ];
}


class Categories {
  static List<String> cities = [
    "الرياض",
    "جدة",
    "مكة المكرمة",
    "المدينة المنورة",
    "الاحساء",
    "الدمام",
    "الطائف",
    "بريدة",
    "تبوك",
    "القطيف",
    "خميس مشيط",
    "الخبر",
    "حفر الباطن",
    "الجبيل",
    "الخرج",
    "أبها",
    "حائل",
    "نجران",
    "ينبع",
    "صبيا",
    "الدوادمي",
    "محافظة بيشة",
    "أبو عريش (جازان)",
    "القنفذة",
    "محايل",
    "سكاكا",
    "عرعر (مدينة)",
    "عنيزة",
    "محافظة القريات",
    "صامطة",
    "جازان",
    "المجمعة",
    "محافظة القويعية",
    "احد المسارحه",
    "الرس",
    "وادي الدواسر",
    "بحرة (مكة)",
    "الباحة",
    "الجموم",
    "رابغ",
    "أحد رفيدة",
    "شرورة",
    "الليث",
    "رفحاء",
    "عفيف",
    "العرضيات",
    "محافظة العارضة",
    "الخفجي",
    "بالقرن",
    "الدرعية",
    "ضمد",
    "طبرجل",
    "بيش",
    "الزلفي",
    "الدرب",
    "الأفلاج (محافظة)",
    "سراة عبيدة",
    "رجال المع",
    "بلجرشي",
    "الحائط",
    "ميسان (محافظة سعودية)",
    "بدر (محافظة)",
    "املج",
    "رأس تنوره",
    "المهد",
    "الدائر",
    "البكيريه",
    "البدائع",
    "خليص",
    "الحناكية",
    "العلا",
    "الطوال",
    "النماص",
    "المجاردة",
    "بقيق",
    "محافظة تثليث",
    "المخواة",
    "محافظة النعيرية",
    "الوجه",
    "ضباء",
    "بارق (محافظة)",
    "طريف (محافظة)",
    "خيبر",
    "أضم",
    "النبهانية",
    "رنيه",
    "دومة الجندل",
    "المذنب",
    "تربه",
    "ظهران الجنوب",
    "حوطة بني تميم",
    "الخرمة",
    "قلوه",
    "شقراء",
    "المويه",
    "المزاحمية",
    "الأسياح",
    "بقعاء",
    "السليل",
    "تيماء (مدينة)",
  ];
}




class Brands {

  static Map<String, List<String>> brands = {
    'bmw': [
      'm1',
      'm2',
      'm3'
    ],
    'audi': [
      'a3',
      'a4',
      'q7'
    ]
  };

  static List<String> models() {
    List<String> m = [];
    for (int i = 2021; i > 1885; i--) {
      m.add(i.toString());
    }
    return m;
  }

  static Map<String, String> logos = {
    'bmw': "https://i2.wp.com/thinkmarketingmagazine.com/wp-content/uploads/2012/08/bmw-logo.png",
    'audi': "https://logos-marques.com/wp-content/uploads/2021/02/Audi-Logo.png"
  };

}