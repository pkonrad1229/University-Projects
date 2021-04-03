#include "mainwindow.h"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    ui->stackedWidget->setCurrentIndex(0);

    ingredientsListModel = new QStringListModel(this);
    recipeListModel = new QStringListModel(this);
    countListModel = new QStringListModel(this);
    countModel = new QStandardItemModel(this);
    ui->recipesTableView->setModel(countModel);
    countModel->setRowCount(0);
    ui->recipesTableView->verticalHeader()->hide();
    ui->recipesTableView->horizontalHeader()->hide();

    ui->countListView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->ingredientsListView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->listView->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->textEdit->setReadOnly(true);

    ui->quantityLineEdit->setValidator(new QDoubleValidator(0, 100, 2, ui->quantityLineEdit));

    setWindowTitle("Recipe list");
}

MainWindow::~MainWindow()
{
    delete ui;
}

// ######### FILE HANDLING SECTION #########

void MainWindow::on_actionOpen_triggered()
{
    currentIndex=-1;
    isSaved = true;
    recipesNameList.clear();
    recipeList.clear();
    QString filename = QFileDialog::getOpenFileName(this, tr("Open JSON file with the recipes"),"", "JSON file(*.json)");
    QFile file(filename);
    currentFile = filename;
    if(!file.open(QIODevice::ReadOnly | QFile::Text)) {
        QMessageBox::warning(this, "Warning", "Cannot open file : " + file.errorString());
        return;
    }


    setWindowTitle(filename);
    QTextStream in(&file);
    QString fileText = in.readAll();
    jsonData = QJsonDocument::fromJson(fileText.toUtf8());
    QJsonObject jsonObject = jsonData.object();

    foreach(const QString& key, jsonObject.keys()) {
        QJsonObject object = jsonObject.value(QString(key)).toObject();
        QJsonArray array = object.value(QString("recipe")).toArray();
        QStringList instructions;
        foreach(const QJsonValue & value, array){
            instructions.append(value.toString());
        }
        QStringList ingredients;
        QList<float> quantity;
        QStringList units;
        foreach(const QString& ingredient, object.keys()){
            if (ingredient != "recipe"){
                QJsonValue value = object.value(QString(ingredient));
                ingredients.append(ingredient);
                QStringList quantityAndUnit = value.toString().split(QString(' '));
                quantity.append(quantityAndUnit[0].toFloat());
                units.append(quantityAndUnit[1]);
            }
        }
        recipesNameList.append(key);
        Recipe recipe(key, instructions, ingredients, quantity, units);
        recipeList.append(recipe);
    }
    updateRecipeList();
    file.close();
}

void MainWindow::on_actionSave_triggered()
{
    if(isSaved){
        QMessageBox::information(this, "File up to date", "Current file is up to date");
        return;
    }
    QFile file(currentFile);
    if(!file.open(QFile::WriteOnly | QFile::Text)) {
        QMessageBox::warning(this, "Warning", "Cannot save file : " + file.errorString());
        return;
    }
    jsonData = updateJson();
    file.write(jsonData.toJson());
    file.close();
    QMessageBox::information(this, "Successfully saved", "Current file was successfully saved");
    isSaved=true;

}

void MainWindow::on_actionSave_As_triggered()
{
    if(currentFile.isEmpty()) {
        QMessageBox::warning(this, "Warning", "Cannot save, open a file first");
        return;
    }
    QString fileName = QFileDialog::getSaveFileName(this, tr("Save as"),"", "JSON file(*.json)");
    QFile file(fileName);
    if(!file.open(QFile::WriteOnly | QFile::Text)) {
        QMessageBox::warning(this, "Warning", "Cannot save file : " + file.errorString());
        return;
    }
    setWindowTitle(fileName);
    currentFile=fileName;
    jsonData = updateJson();
    file.write(jsonData.toJson());
    file.close();
    isSaved = true;
}

void MainWindow::closeEvent(QCloseEvent *event)
{

    if(!isSaved){
        event->ignore();
        if (QMessageBox::Yes == QMessageBox::question(this, "File not saved", "Current file is not saved. Do you want to exit?", QMessageBox::Yes | QMessageBox::No))
            event->accept();
    }
}

// ######### RECIPE LIST WINDOW SECTION  #########

void MainWindow::on_listView_clicked(const QModelIndex &index)
{
    currentIndex=index.row();
    updateRecipePreview();
}

void MainWindow::on_addPushButton_clicked()
{
    addMode = true;
    ui->recipeLineEdit->clear();
    ui->instructionsTextEdit->clear();
    ingredientsListModel->setStringList(QStringList{});
    ui->ingredientsListView->setModel(ingredientsListModel);
    ui->ingredientLineEdit->clear();
    ui->quantityLineEdit->clear();
    ui->unitLineEdit->clear();
    ingredientName.clear();
    ingredientQuantity.clear();
    ingredientUnit.clear();
    ingredientsList.clear();
    ui->menubar->hide();
    ui->stackedWidget->setCurrentIndex(1);
}

void MainWindow::on_editPushButton_clicked()
{
    if(currentIndex < 0 || currentIndex >= recipeList.size()){
        QMessageBox::warning(this, "Warning", "Select a recipe which you want to edit");
        return;
    }

    ui->ingredientLineEdit->clear();
    ui->quantityLineEdit->clear();
    ui->unitLineEdit->clear();
    addMode=false;
    ui->recipeLineEdit->setText(recipeList[currentIndex].getName());

    ui->instructionsTextEdit->clear();
    for(auto &data : recipeList[currentIndex].getInstructions())
    {
        ui->instructionsTextEdit->append(data);
    }

    ingredientName=recipeList[currentIndex].getIngredients();
    ingredientQuantity=recipeList[currentIndex].getQuantity();
    ingredientUnit=recipeList[currentIndex].getUnit();
    ingredientsList.clear();
    for (int i=0; i<ingredientName.size();i++){
        ingredientsList.append(ingredientName[i] + QString(" ") + QString::number(ingredientQuantity[i])+ QString(" ") + ingredientUnit[i]);
    }

    ingredientsListModel->setStringList(ingredientsList);
    ui->ingredientsListView->setModel(ingredientsListModel);

    ui->menubar->hide();
    ui->stackedWidget->setCurrentIndex(1);
}

void MainWindow::on_deletePushButton_clicked()
{
    if(currentIndex < 0 || currentIndex >= recipeList.size()){
        QMessageBox::warning(this, "Warning", "Select a recipe which you want to delete");
        return;
    }

    recipeList.removeAt(currentIndex);
    recipesNameList.removeAt(currentIndex);
    currentIndex=-1;
    isSaved = false;
    updateRecipeList();
    updateRecipePreview();
}

void MainWindow::on_countPageButton_clicked()
{
    countListModel->setStringList(QStringList{});
    ui->countListView->setModel(countListModel);
    foreach(const QString &name, recipesNameList)
    {
        QStandardItem *recipeName = new QStandardItem(name);
        QStandardItem *value = new QStandardItem("0");

        QList<QStandardItem*> row;
        row << recipeName << value;
        countModel->appendRow(row);
    }


    ui->menubar->hide();
    ui->stackedWidget->setCurrentIndex(2);
}

// ######### COUNT PAGE

void MainWindow::on_countButton_clicked()
{
    ingredientName.clear();
    ingredientQuantity.clear();
    ingredientUnit.clear();
    ingredientsList.clear();
    QString recipeName;
    QStringList recipeInstructions;
    QStringList recipeIngredient;
    QList<float> recipeQuantity;
    QStringList recipeUnit;
    bool wasAdded;

    for (int i=0; i<recipesNameList.count(); i++){
        if(ui->recipesTableView->model()->index(i,1).data().toInt()<0){
            QMessageBox::warning(this, "Warning", "Quantity must be a positive integer");
            return;
        }
        if(!(ui->recipesTableView->model()->index(i,1).data().toInt()==0)){
            recipeName = recipeList[i].getName();
            recipeInstructions = recipeList[i].getInstructions();
            recipeIngredient = recipeList[i].getIngredients();
            recipeQuantity = recipeList[i].getQuantity();
            recipeUnit = recipeList[i].getUnit();

            for(int ingredientIndex=0; ingredientIndex < recipeIngredient.size(); ingredientIndex++){
                wasAdded = false;

                for(int addedIngredient=0; addedIngredient < ingredientName.size(); addedIngredient++){
                    if(recipeIngredient[ingredientIndex]==ingredientName[addedIngredient] && recipeUnit[ingredientIndex]==ingredientUnit[addedIngredient]){
                        ingredientQuantity[addedIngredient]+=recipeQuantity[ingredientIndex] * ui->recipesTableView->model()->index(i,1).data().toInt();
                        wasAdded = true;
                    }
                }
                if(!wasAdded){
                    ingredientName.append(recipeIngredient[ingredientIndex]);
                    ingredientQuantity.append(recipeQuantity[ingredientIndex]*ui->recipesTableView->model()->index(i,1).data().toInt());
                    ingredientUnit.append(recipeUnit[ingredientIndex]);
                }
            }
        }
    }

    for(int i = 0; i<ingredientName.size(); i++){
        ingredientsList.append(ingredientName[i] + QString(" ") + QString::number(ingredientQuantity[i])+ QString(" ") + ingredientUnit[i]);
    }

    ingredientsList.sort();
    updateCountList();
}

void MainWindow::on_backButton_clicked()
{
    countModel->clear();
    ui->menubar->show();
    ui->stackedWidget->setCurrentIndex(0);
}
// ######### ADD/EDIT WINDOW SECTION #########

void MainWindow::on_okButton_clicked()
{
    if(ui->recipeLineEdit->text().isEmpty()              ||
            ui->instructionsTextEdit->toPlainText().isEmpty() ||
            ingredientsList.isEmpty() ){
        QMessageBox::warning(this, "Warning", "Cannot add ingredients, all values must be entered!");
        return;
    }
    QString name = ui->recipeLineEdit->text();
    QStringList instructions = ui->instructionsTextEdit->toPlainText().split(QString('\n'));

    if(addMode){
        currentIndex=recipeList.size();
        recipeList.append(Recipe(name, instructions, ingredientName, ingredientQuantity, ingredientUnit));
        recipesNameList.append(name);

    } else {
        if(recipeList[currentIndex].getName() == name && recipeList[currentIndex].getInstructions() == instructions &&
                recipeList[currentIndex].getIngredients() == ingredientName && recipeList[currentIndex].getQuantity() == ingredientQuantity &&
                recipeList[currentIndex].getUnit() == ingredientUnit){
            QMessageBox::information(this, "No changes made", "No changes were made to the recipe");
        } else {

            recipesNameList[currentIndex] = name;
            recipeList[currentIndex].setName(name);
            recipeList[currentIndex].setInstructions(instructions);
            recipeList[currentIndex].setIngredients(ingredientName);
            recipeList[currentIndex].setQuantity(ingredientQuantity);
            recipeList[currentIndex].setUnit(ingredientUnit);
        }
    }
    isSaved = false;
    updateRecipeList();
    updateRecipePreview();
    ui->menubar->show();
    ui->stackedWidget->setCurrentIndex(0);

}

void MainWindow::on_cancelButton_clicked()
{
    ui->menubar->show();
    ui->stackedWidget->setCurrentIndex(0);
}



// ######### INGREDIENTS HANDLING #########

void MainWindow::on_ingredientsListView_clicked(const QModelIndex &index)
{
    ui->ingredientLineEdit->setText(ingredientName[index.row()]);
    ui->quantityLineEdit->setText(QString::number(ingredientQuantity[index.row()]));
    ui->unitLineEdit->setText(ingredientUnit[index.row()]);
}



void MainWindow::on_addIngredientButton_clicked()
{
    if(ui->ingredientLineEdit->text().isEmpty() ||
            ui->quantityLineEdit->text().isEmpty()   ||
            ui->unitLineEdit->text().isEmpty() ) {
        QMessageBox::warning(this, "Warning", "Cannot add ingredient, all values must be entered!");
        return;
    }
    if(ingredientName.contains(ui->ingredientLineEdit->text())){
        QMessageBox::warning(this, "Warning", "Cannot add ingredient, such ingredient already exists!");
        return;
    }
    ingredientsList.append(ui->ingredientLineEdit->text() + " " + ui->quantityLineEdit->text() + " " + ui->unitLineEdit->text());
    ingredientName.append(ui->ingredientLineEdit->text());
    ingredientQuantity.append(ui->quantityLineEdit->text().toFloat());
    ingredientUnit.append(ui->unitLineEdit->text());

    ui->ingredientLineEdit->clear();
    ui->quantityLineEdit->clear();
    ui->unitLineEdit->clear();

    updateIngredientList();
}

void MainWindow::on_saveIngredientButton_clicked()
{
    if(ui->ingredientLineEdit->text().isEmpty() ||
            ui->quantityLineEdit->text().isEmpty()   ||
            ui->unitLineEdit->text().isEmpty() ) {
        QMessageBox::warning(this, "Warning", "Cannot save ingredient, all values must be entered!");
        return;
    }
    if(ingredientName.contains(ui->ingredientLineEdit->text())) {
        int index = ingredientName.indexOf(ui->ingredientLineEdit->text());
        ingredientQuantity[index]=ui->quantityLineEdit->text().toFloat();
        ingredientUnit[index]=ui->unitLineEdit->text();
        ingredientsList[index] = ui->ingredientLineEdit->text() + " " + ui->quantityLineEdit->text() + " " + ui->unitLineEdit->text();
        updateIngredientList();
    } else {
        QMessageBox::warning(this, "Warning", "Cannote save non-existent ingredient, use 'Add' for that purpose");
    }
}

void MainWindow::on_deleteIngredientButton_clicked()
{
    if(ui->ingredientLineEdit->text().isEmpty() ||
            ui->quantityLineEdit->text().isEmpty()   ||
            ui->unitLineEdit->text().isEmpty() ) {
        QMessageBox::warning(this, "Warning", "Cannot delete ingredient, all values must be entered!");
        return;
    }
    if(ingredientName.contains(ui->ingredientLineEdit->text())) {
        int index = ingredientName.indexOf(ui->ingredientLineEdit->text());
        if(ui->quantityLineEdit->text().toFloat() != ingredientQuantity[index] || ui->unitLineEdit->text() != ingredientUnit[index]){
            QMessageBox::warning(this, "Warning", "Cannot delete ingredient, all values entered must be the same!");
            return;
        } else {
            ingredientName.removeAt(index);
            ingredientQuantity.removeAt(index);
            ingredientUnit.removeAt(index);
            ingredientsList.removeAt(index);
            updateIngredientList();
        }
    } else {
        QMessageBox::warning(this, "Warning", "Cannot delete non-existent ingredient!");
        return;
    }
}

// ######### UPDATE FUNCTIONS #########

void MainWindow::updateRecipeList()
{
    recipeListModel->setStringList(recipesNameList);
    ui->listView->setModel(recipeListModel);
}

void MainWindow::updateRecipePreview()
{

    ui->textEdit->clear();
    if(currentIndex == -1){
        return;
    }
    for(auto &data : recipeList[currentIndex].getInstructions())
    {
        ui->textEdit->append(data);
    }
    ui->textEdit->append(QString('\n'));

    for (int i =0; i<recipeList[currentIndex].getIngredients().size(); i++){
        ui->textEdit->append(recipeList[currentIndex].getIngredients().at(i) + " " +
                             QString::number(recipeList[currentIndex].getQuantity().at(i))+ " " +
                             recipeList[currentIndex].getUnit().at(i));
    }
}

void MainWindow::updateIngredientList()
{
    ingredientsListModel->setStringList(ingredientsList);
    ui->ingredientsListView->setModel(ingredientsListModel);
}

void MainWindow::updateCountList()
{
    countListModel->setStringList(ingredientsList);
    ui->countListView->setModel(countListModel);
}

QJsonDocument MainWindow::updateJson()
{
    QJsonObject jsonObject;
    for (int recipeIndex = 0; recipeIndex<recipeList.size(); recipeIndex++){
        QJsonObject recipe;
        QJsonArray instructions;
        foreach (const QString &instruction, recipeList[recipeIndex].getInstructions()){
            instructions.append(QJsonValue(instruction));
        }
        recipe.insert("recipe", instructions);
        ingredientName = recipeList[recipeIndex].getIngredients();
        ingredientQuantity = recipeList[recipeIndex].getQuantity();
        ingredientUnit = recipeList[recipeIndex].getUnit();
        for (int ingredientIndex = 0; ingredientIndex < ingredientName.size(); ingredientIndex++) {
            recipe.insert(ingredientName[ingredientIndex], QJsonValue(QString::number(ingredientQuantity[ingredientIndex])+ " " +
                                                                      ingredientUnit[ingredientIndex]));
        }
        jsonObject.insert(recipesNameList[recipeIndex], recipe);
    }
    return QJsonDocument(jsonObject);
}









