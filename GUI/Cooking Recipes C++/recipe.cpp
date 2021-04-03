#include "recipe.h"

Recipe::Recipe::Recipe(QString name, QStringList instructions, QStringList ingredientName, QList<float> ingredientQuantity, QStringList ingredientUnit) {
    this->name=name;
    this->instructions=instructions;
    this->ingredientName=ingredientName;
    this->ingredientQuantity=ingredientQuantity;
    this->ingredientUnit=ingredientUnit;
}

Recipe::Recipe::~Recipe()
{

}

QString Recipe::Recipe::getName()
{
    return this->name;
}

QStringList Recipe::Recipe::getInstructions()
{
    return this->instructions;
}

QStringList Recipe::Recipe::getIngredients()
{
    return this->ingredientName;
}

QList<float> Recipe::Recipe::getQuantity()
{
    return this->ingredientQuantity;
}

QStringList Recipe::Recipe::getUnit()
{
    return this->ingredientUnit;
}

void Recipe::Recipe::setName(QString newName)
{
    this->name=newName;
}

void Recipe::Recipe::setInstructions(QStringList newInstructions)
{
    this->instructions=newInstructions;
}

void Recipe::Recipe::setIngredients(QStringList newIngredients)
{
    this->ingredientName=newIngredients;
}

void Recipe::Recipe::setQuantity(QList<float> newQuantity)
{
    this->ingredientQuantity=newQuantity;
}

void Recipe::Recipe::setUnit(QStringList newUnit)
{
    this->ingredientUnit=newUnit;
}

