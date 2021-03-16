import 'a_pages_index.dart';

class FaqListScreen extends StatefulWidget {
  static const String routeName = "/faq_screen";

  @override
  _FaqListScreenState createState() => _FaqListScreenState();
}

class _FaqListScreenState extends State<FaqListScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    print('page frame');

    return YipliPageFrame(
      title: Text('Faq'),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.question_answer_outlined, color: yipliNewBlue),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What help you need?',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        faqList(context, "Setup and Usage"),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: yipliBlack,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: yipliNewBlue,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Setup and Usage',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        faqList(context, "Features"),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: yipliBlack,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: yipliNewBlue,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Features',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        faqList(context, "Technical"),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: yipliBlack,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: yipliNewBlue,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Technical',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        faqList(context, "Rewards"),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: yipliBlack,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: yipliNewBlue,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rewards',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.3,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget faqList(BuildContext context, String category) {
    Query faqFromDB = FirebaseDatabaseUtil()
        .rootRef
        .child("inventory")
        .child("faq")
        .orderByChild("category")
        .equalTo(category);

    return StreamBuilder<Event>(
        stream: faqFromDB.onValue,
        builder: (context, event) {
          if ((event.connectionState == ConnectionState.waiting) ||
              event.hasData == null)
            return YipliLoaderMini(loadingMessage: 'Loading Faq');
          print(event.data.snapshot.value);

          return ChangeNotifierProvider<FaqModel>(
            create: (context) {
              FaqModel faqModel = new FaqModel();
              faqModel.initialize();
              print("Returned faq model");
              return faqModel;
            },
            child: YipliPageFrame(
              title: Text('Faq:' + ' ' + category),
              child: Consumer<FaqModel>(builder: (context, faqModel, child) {
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: event.data.snapshot.value.length,
                    itemBuilder: (context, index) {
                      return FaqListWidget(faqModel.allFaq[index]);
                    });
              }),
            ),
          );
        });
  }
}
