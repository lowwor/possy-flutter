import 'package:flutter/material.dart';
import 'package:flutter_posy/bloc/bloc_provider.dart';
import 'package:flutter_posy/pages/calculator/calculator_bloc.dart';
import 'package:flutter_posy/utils/DecimalTextInputFormatter.dart';
import 'package:flutter_posy/widgets/RadioItem.dart';
import 'package:flutter_posy/widgets/ResultItem.dart';

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CalculatorBloc _calculatorBloc = BlocProvider.of(context);
    TextEditingController _maxRiskTc =
        initialValue("${CalculatorBloc.defaultMaxRisk}");
    TextEditingController _positionSizeTc =
        initialValue("${CalculatorBloc.defaultPositionSize}");
    TextEditingController _entryPriceTc =
        initialValue("${CalculatorBloc.defaultEntryPrice.toStringAsFixed(8)}");
    TextEditingController _stopPriceTc =
        initialValue("${CalculatorBloc.defaultStopPrice.toStringAsFixed(8)}");
    TextEditingController _targetPriceTc =
        initialValue("${CalculatorBloc.defaultTargetPrice.toStringAsFixed(8)}");

    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          child: StreamBuilder(
              stream: _calculatorBloc.errorMsg,
              builder: (context, snapshot) {
                return snapshot.error != null
                    ? Container(
                        height: 30.0,
                        width: MediaQuery.of(context).size.width,
                        alignment: new Alignment(0.0, 0.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                        ),
                        child: Text(
                          snapshot.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ))
                    : Container(width: 0.0, height: 0.0);
              }),
        ),
        Expanded(
          child: ListView(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: StreamBuilder(
                        stream: _calculatorBloc.maxRisk,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _maxRiskTc,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 1)
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: 'Max Risk %',
                            ),
                            onChanged: (value) {
                              _calculatorBloc
                                  .changeMaxRisk(double.parse(value));
                            },
                          );
                        }),
                  ),
                  Expanded(
                      flex: 2,
                      child: RadioItem(RadioModel(false, '0.5%', () {
                        _maxRiskTc.text = '0.5';
                        _calculatorBloc.changeMaxRisk(0.5);
                      }))),
                  Expanded(
                      flex: 2,
                      child: RadioItem(RadioModel(false, '1%', () {
                        _maxRiskTc.text = '1';
                        _calculatorBloc.changeMaxRisk(1);
                      }))),
                  Expanded(
                      flex: 2,
                      child: RadioItem(RadioModel(false, '2%', () {
                        _maxRiskTc.text = '2';
                        _calculatorBloc.changeMaxRisk(2);
                      }))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: _calculatorBloc.positionSize,
                  initialData: 1,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _positionSizeTc,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 8)
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Position Size',
                      ),
                      onChanged: (value) {
                        _calculatorBloc.changePositionSize(double.parse(value));
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: _calculatorBloc.entryPrice,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _entryPriceTc,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 8)
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Entry Price',
                        errorText: snapshot.error,
                      ),
                      onChanged: (value) {
                        _calculatorBloc.changeEntryPrice(double.parse(value));
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: _calculatorBloc.stopPrice,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _stopPriceTc,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 8)
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Stop Price',
                        errorText: snapshot.error,
                      ),
                      onChanged: (value) {
                        _calculatorBloc.changeStopPrice(double.parse(value));
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: _calculatorBloc.targetPrice,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _targetPriceTc,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 8)
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Target Price',
                        errorText: snapshot.error,
                      ),
                      onChanged: (value) {
                        _calculatorBloc.changeTargetPrice(double.parse(value));
                      },
                    );
                  }),
            ),
          ]),
        )
      ]),
      floatingActionButton: StreamBuilder<bool>(
          stream: _calculatorBloc.priceValid,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return FloatingActionButton(
                child: Icon(Icons.show_chart, color: Colors.white),
                onPressed: !(snapshot.hasData)
                    ? () {}
                    : () async {
                        // launch the registration process
                        await _calculatorBloc.calculate();
                        goToDialog(context, _calculatorBloc);
                      });
          }),
    );
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  goToDialog(context, calculatorBloc) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successTicket(calculatorBloc),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  successTicket(CalculatorBloc calculatorBloc) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                ResultItem("Suggessted Quantity",
                    "${calculatorBloc.unitsToBuy} units"),
                ResultItem("Position Cost", "${calculatorBloc.positionCost}"),
                ResultItem("Position Risk",
                    "${calculatorBloc.positionRisk} (${calculatorBloc.lostPercent}%)"),
                ResultItem("Target Gain",
                    "${calculatorBloc.targetGain} (${calculatorBloc.gainPercent}%)"),
                ResultItem("R:R", "${calculatorBloc.rr}"),
              ],
            ),
          ),
        ),
      );
}
