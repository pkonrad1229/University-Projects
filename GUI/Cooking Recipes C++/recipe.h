#ifndef RECIPE_H
#define RECIPE_H
#include <QStringListModel>

class Recipe {
private:
    QString name;
    QStringList instructions;
    QStringList ingredientName;
    QList<float> ingredientQuantity;
    QStringList ingredientUnit;

public:
    Recipe(QString name, QStringList instructions, QStringList ingredientName, QList<float> ingredientQuantity, QStringList ingredientUnit);
    ~Recipe();
    QString getName();
    QStringList getInstructions();
    QStringList getIngredients();
    QList<float> getQuantity();
    QStringList getUnit();
    void setName(QString);
    void setInstructions(QStringList);
    void setIngredients(QStringList);
    void setQuantity(QList<float>);
    void setUnit(QStringList);

};
#endif // RECIPE_H
