import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shops_orders/providers/product_provider.dart';
import 'package:shops_orders/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '\edit=product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _editProduct = ProductProvider(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct =
            Provider.of<ProductsProvider>(context).findById(productId);
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        print(_initValues);
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editProduct.id == null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('error'),
                  content: Text(error.toString()),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
      }
    } else {
      await Provider.of<ProductsProvider>(context, listen: false)
          .editProduct(_editProduct.id, _editProduct);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter title';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editProduct = ProductProvider(
                              title: val,
                              price: _editProduct.price,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              id: _editProduct.id);
                        },
                        initialValue: _initValues['title'],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter price';
                          }
                          if (double.tryParse(val) == null) {
                            return 'Enter valid price';
                          }
                          if (double.parse(val) <= 0.0) {
                            return 'Enter price greater than zero';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editProduct = ProductProvider(
                              title: _editProduct.title,
                              price: double.parse(val),
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              id: _editProduct.id);
                        },
                        initialValue: _initValues['price'],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter description';
                          }
                          if (val.length < 2) {
                            return 'Enter long description';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _editProduct = ProductProvider(
                              title: _editProduct.title,
                              price: _editProduct.price,
                              description: val,
                              imageUrl: _editProduct.imageUrl,
                              id: _editProduct.id);
                        },
                        initialValue: _initValues['description'],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              // focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (val) {
                                _editProduct = ProductProvider(
                                    title: _editProduct.title,
                                    price: _editProduct.price,
                                    description: _editProduct.description,
                                    imageUrl: val,
                                    id: _editProduct.id);
                              },
                              // initialValue: _initValues['imageUrl'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
