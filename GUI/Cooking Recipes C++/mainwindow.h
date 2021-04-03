#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QStringListModel>
#include <QAbstractItemView>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QMainWindow>
#include <QFileDialog>
#include <QMessageBox>
#include <QCloseEvent>
#include <QStandardItemModel>

#include "recipe.h"


QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_actionOpen_triggered();

    void on_listView_clicked(const QModelIndex &index);

    void on_addPushButton_clicked();

    void on_editPushButton_clicked();

    void on_deletePushButton_clicked();

    void on_okButton_clicked();

    void on_cancelButton_clicked();

    void on_ingredientsListView_clicked(const QModelIndex &index);

    void on_addIngredientButton_clicked();

    void on_actionSave_triggered();

    void on_actionSave_As_triggered();

    void on_saveIngredientButton_clicked();

    void on_deleteIngredientButton_clicked();

    void on_countPageButton_clicked();

    void on_backButton_clicked();

    void on_countButton_clicked();

private:
    Ui::MainWindow *ui;
    void updateRecipeList();
    void updateRecipePreview();
    void updateIngredientList();
    void updateCountList();
    QJsonDocument updateJson();

    QString currentFile;
    QList<Recipe> recipeList;
    QStringList recipesNameList;
    QStringListModel *recipeListModel;
    QJsonDocument jsonData;
    int currentIndex=-1;
    bool addMode;
    bool isSaved;

    QStringListModel *ingredientsListModel;
    QStringList ingredientsList;
    QStringList ingredientName;
    QList<float> ingredientQuantity;
    QStringList ingredientUnit;

    QStringListModel *countListModel;
    QStandardItemModel *countModel;

    void closeEvent(QCloseEvent *event);
};
#endif // MAINWINDOW_H
