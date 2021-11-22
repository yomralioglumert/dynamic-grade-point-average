import 'package:dinamik_not_ortalama_hesaplama/constants/app_constants.dart';
import 'package:dinamik_not_ortalama_hesaplama/helper/data_helper.dart';
import 'package:dinamik_not_ortalama_hesaplama/model/ders.dart';
import 'package:dinamik_not_ortalama_hesaplama/widgets/ders_listesi.dart';
import 'package:dinamik_not_ortalama_hesaplama/widgets/harf_dropdown_widget.dart';
import 'package:dinamik_not_ortalama_hesaplama/widgets/kredi_dropdown_widget.dart';
import 'package:dinamik_not_ortalama_hesaplama/widgets/ortalama_goster.dart';
import 'package:flutter/material.dart';

class OrtalamaHesaplaPage extends StatefulWidget {
  OrtalamaHesaplaPage({Key? key}) : super(key: key);

  @override
  _OrtalamaHesaplaPageState createState() => _OrtalamaHesaplaPageState();
}

class _OrtalamaHesaplaPageState extends State<OrtalamaHesaplaPage> {
  double secilenDeger = 4;
  double secilenKredi = 1;
  String girilenDersAdi = '';

  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            Sabitler.baslikText,
            style: Sabitler.baslikStyle,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //form
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildForm(),
              ),
              Expanded(
                flex: 1,
                child: OrtalamaGoster(
                    dersSayisi: DataHelper.tumEklenenDersler.length,
                    ortalama: DataHelper.ortalamaHesapla()),
              ),
            ],
          ),

          //Liste
          Expanded(
            child: DersListesi(
              onDismiss: (index) {
                DataHelper.tumEklenenDersler.removeAt(index);
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          Padding(
            padding: Sabitler.edgeInsetsSymmetric,
            child: _buildTextFormField(),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: Sabitler.edgeInsetsSymmetric,
                  child: HarfDropdownWidget(
                    onHarfSecildi: (harf) {
                      secilenDeger = harf;
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: Sabitler.edgeInsetsSymmetric,
                  child: KrediDropdownWidget(
                    onKrediSecildi: (kredi) {
                      secilenKredi = kredi;
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: _dersEkleveOrtalamaHesapla,
                icon: Icon(Icons.arrow_forward_sharp),
                color: Sabitler.anaRenk,
                iconSize: 30,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  _buildTextFormField() {
    return TextFormField(
      onSaved: (deger) {
        setState(() {
          girilenDersAdi = deger!;
        });
      },
      validator: (s) {
        if (s!.length <= 0) {
          return 'Ders Adı Giriniz';
        } else
          return null;
      },
      decoration: InputDecoration(
          hintText: 'Matematik',
          border: OutlineInputBorder(
              borderRadius: Sabitler.borderRadius, borderSide: BorderSide.none),
          filled: true,
          fillColor: Sabitler.anaRenk.shade100.withOpacity(0.3)),
    );
  }

  void _dersEkleveOrtalamaHesapla() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      var eklenecekDers = Ders(
          ad: girilenDersAdi,
          harfDegeri: secilenDeger,
          krediDegeri: secilenKredi);
      DataHelper.dersEkle(eklenecekDers);
      setState(() {});
    }
  }
}
