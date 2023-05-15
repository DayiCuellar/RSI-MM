//+------------------------------------------------------------------+
//|                                        EA_RSI-NOTIFICACIONES.mq4 |
//|                                                        @RobaPips |
//|                https://www.facebook.com/robapips?mibextid=ZbWKwL |
//+------------------------------------------------------------------+
#property copyright "@RobaPips"
#property link      "https://www.facebook.com/robapips?mibextid=ZbWKwL"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                         DEFINE
//+------------------------------------------------------------------+
#define  ESPERA  250
#define  XX 20
#define  YY 20
//+------------------------------------------------------------------+
//|                      ENUM
//+------------------------------------------------------------------+
enum ENUM_DIR
{
   nada,
   buy,
   sell,
};
//+------------------------------------------------------------------+
//|                     VARIABLES EXTERNAS
//+------------------------------------------------------------------+
input string Separador_RSI = "---------------------PARAMETROS RSI";
extern int Periodo_RSI = 14;
extern int Nivel_Sobre_Compra = 80;
extern int Nivel_Sobre_Venta = 20;
//---
input string Separador_Media_Movil = "--------------PARAMETROS MEDIA MOVIL";
extern int Periodo_Media_Movil = 100;
//---
input string Separador_Operaciones = "--------------PARAMETROS OPERACIONES";
extern double Pips_SL = 0;
extern double Pips_TP = 0;
extern double Lotaje = 0.01;
input int num_mag = 0;
//---
//+------------------------------------------------------------------+
//|                     VARIABLES GLOBALES
//+------------------------------------------------------------------+
ENUM_DIR direccion = nada;
double valor_rsi = 0,
       valor_mm = 0;
bool compra_realizada = false,
     venta_realizada = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
//+------------------------------------------------------------------+
//|               VALORES DE LOS INDICADORES
//+------------------------------------------------------------------+
   valor_rsi = iRSI(_Symbol, PERIOD_CURRENT, Periodo_RSI, PRICE_CLOSE, 1);
   valor_mm = iMA (_Symbol, PERIOD_CURRENT, Periodo_Media_Movil, 0, MODE_EMA, PRICE_CLOSE, 1);
//+------------------------------------------------------------------+
//|                DIRECCION DE LAS OPERACIONES
//+------------------------------------------------------------------+
//--- COMPRAS
   if(Bid > valor_mm && valor_rsi <= Nivel_Sobre_Venta)
   {
      direccion = buy;
   }
//--- VENTAS
   else if(Bid < valor_mm && valor_rsi >= Nivel_Sobre_Compra)
   {
      direccion = sell;
   }
//+------------------------------------------------------------------+
//|              APERTURA DE OPERACIONES
//+------------------------------------------------------------------+
//--- COMPRAS
   if(direccion == buy && compra_realizada == false)
   {
      bool m = OrderSend(_Symbol, OP_BUY, Lotaje, Ask, 0, Ask - Pips_SL * 10 * Point, Ask + Pips_TP * 10 * Point, NULL, num_mag);
      direccion = nada;
      compra_realizada = true;
   }
// VENTAS
   else if(direccion == sell && venta_realizada == false)
   {
      bool j = OrderSend(_Symbol, OP_BUY, Lotaje, Bid, 0, Bid + Pips_SL * 10 * Point, Bid - Pips_TP * 10 * Point, NULL, num_mag);
      direccion = nada;
      venta_realizada = true;
   }
//---
   if(compra_realizada == true && valor_rsi >= 50)
   {
      compra_realizada = false;
   }
   else if(venta_realizada == true && valor_rsi <= 50)
   {
      venta_realizada = false;
   }
} // FIN ON TICK
//+------------------------------------------------------------------+
