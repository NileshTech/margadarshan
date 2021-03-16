import 'package:margadarshan/page_models/page_model_index.dart';

class FaqModel extends ChangeNotifier {
  static String refName = "faq";
  static DatabaseReference getFaqDatabaseRefName() {
    return FirebaseDatabaseUtil().faqRef;
  }

  List<FaqDetails> allFaq;

  StreamTransformer faqModelTransformer;

  FaqModel() {
    allFaq = new List<FaqDetails>();
  }

  void handleFaqDataStreamTransform(Event event, EventSink<FaqModel> sink) {
    // print("Adding handler for stream transformation in faq model");
    FaqModel changedFaqModel = FaqModel.fromSnapshotValue(event.snapshot);
    sink.add(changedFaqModel);
  }

  void initialize() {
    print("Creating the stream transformer for faq model");
    faqModelTransformer = StreamTransformer<Event, FaqModel>.fromHandlers(
        handleData: handleFaqDataStreamTransform);
    //print("Adding faq listener");
    FirebaseDatabaseUtil()
        .getModelStreamFromDbReference(
            getFaqDatabaseRefName(), faqModelTransformer)
        .listen((changedData) {
      setChangedFaqData(changedData);
      notifyListeners();
      // print("Listeners notified in faq model!!");
    });
  }

  void setChangedFaqData(FaqModel changedFaqData) {
    allFaq = changedFaqData.allFaq;
  }

  FaqModel.fromSnapshotValue(DataSnapshot faqSnapshot) {
    allFaq = new List<FaqDetails>();
    List<dynamic> fetchedFaqMap = faqSnapshot.value;
    if (fetchedFaqMap != null) {
      for (var faq in fetchedFaqMap.sublist(0)) {
        FaqDetails faqDetails =
            new FaqDetails(faq['index'], faq['question'], faq['answer']);
        allFaq.add(faqDetails);
      }
    } else
      print('faq list null');
  }
}
