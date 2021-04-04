unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Image1: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button3: TButton;
    Label15: TLabel;
    Label16: TLabel;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
  public
  end;

var
  Form2: TForm2;

implementation
uses Unit1;

{$R *.dfm}

var i, pressed, delete_used, mistakes, seconds, minutes: Integer;
var time, speed, graph_speed: Real;
var word, question: String;
var exit, big: Boolean;
var char_getted: Char;

var words_arr: Array[1..15] of String;

var easy_words: Array[1..15] of String = (
'привет', 'длинный текст', 'русский язык',
'политех', 'парочка слов', 'ясный день',
'цикл фор', 'вкусное мороженое', 'просто текст',
'язык паскаля', 'гугл хром', 'лазерная мышь',
'яркая луна', 'телеграмма', 'острый нож'
);

var medium_words: Array[1..15] of String = (
'Я - программист', 'Я учусь в "ППК"', 'Ну, и что?',
'Передайте чай, пожалуйста!', 'Это средний уровень, тут есть знаки!', 'Выезжаю за линию!!!',
'Быстрее, еще быстрее!', 'Я - студент ППК', 'Укуси меня, пчела!',
'Дота 2 = зависимость', 'Такой тест попробуй напиши быстро!', 'Садись, Сидоров, 5!',
'Рыба - текст, и все!', 'Массив из 15-ти элементов', 'Это 57 строка кода'
);

var hard_words: Array[1..15] of String = (
'Товарищи! сложившаяся структура организации представляет собой интересный эксперимент проверки новых предложений.',
'С целью снизить число людей с ожирением рестораны быстрого питания и сети вводят новые, более полезные опции.',
'Практически все из нас знают, что есть полезная и вредная еда, мы делим все продукты на плохие и хорошие.',
'Являясь одной из самых распространённых в мире сельскохозяйственных культур, рис занимает главенствие в кухне.',
'Генерация текста осуществляется по количеству абзацев. Можно выбрать тематику рыбы-текста.',
'Не стоит использовать сгенерированный текст для реальных проектов. Используйте только для тестирования.',
'Интересно, что первый компьютер был размером с микроавтобус и весил почти тонну. Вы это знали?',
'Компьютерные технологии стали неотъемлемой частью жизни людей. Эти технологии имеют свои корни.',
'Мышь перемещает стрелку (или курсор) на экране компьютера. Эта идея пришла специалисту Дугласу Энгельбарту.',
'Сегодня люди не представляют свою жизнь без современных технологий и, в т.ч. без компьютера. Вот и вся история!',
'Длиннофокусные объективы выполняют съемку с более узким углом обзора, чем угол зрения человеческого глаза.',
'Одна из самых распространенных поз для фотосессии – рука возле головы.',
'Кадрируйте снимки, обрезайте лишние детали, которые портят фотографии. Это значительно повысит качество работы!',
'Конечно, фотография, как и любое другое искусство, прежде всего является формой самовыражения мастера.',
'Оседлое население Орды включало волжских булгар, мордовские народы, славян, греков и др.'
);


procedure TForm2.Button1Click(Sender: TObject);
begin
  {В зависимости от того, какой мы radiobutton прожали, выбирается
   массив с текстом и прибаляется к новому}
  if Form1.RadioButton1.Checked = True then begin
    for i := 1 to 15 do begin
      words_arr[i] := easy_words[i];
    end;
  end
  else
    if Form1.RadioButton2.Checked = True then begin
      for i := 1 to 15 do begin
        words_arr[i] := medium_words[i];
      end;
    end
    else
      if Form1.RadioButton3.Checked = True then begin
        for i := 1 to 15 do begin
          words_arr[i] := hard_words[i];
        end;
      end;

  {Обнуляем все нужные переменные}
  word := '';
  exit := False;
  big := False;

  pressed := 0;
  delete_used := 0;
  mistakes := 0;
  speed := 0;

  seconds := 0;
  minutes := 0;
  time := 0;

  {Скрываем кнопки старта и выхода}
  Button1.Visible := False;
  Button2.Visible := False;
  Button3.Visible := False;
  Button4.Visible := False;

  {Рандомим первый вопрос}
  question := words_arr[Random(14) + 1];
  Label1.Caption := question;

  {Максимальный лимит раунда 1000 секунд}
  while seconds + (minutes * 60) < 1000 do begin
    {Цикл for проходит по всем id кнопок}
    for i:=0 to 255 do
      {Если id кнопки найден, выполняется сл. условие...}
      if getasynckeystate(i)<>0 then begin
        {Особо важные кнопки такие как BackSpace(8), Caps(20), Esc(27),
         Space(32), Tab(9) будут выполнять свою функцию}
        case i of
          8: begin
            if length(word) > 0 then begin
              {Удаление последнего символа у строки}
              delete(word, length(word), length(word));
              delete_used := delete_used + 1;
              sleep(10);
            end;
          end;
          20: begin
            case big of
              True: big := False;
              False: big := True;
            end;
            sleep(10);
          end;
          27: exit := True;
          32: begin
            word := word + ' ';
            sleep(10);
          end;
          9: begin
            word := word + '   ';
            sleep(10);
          end;
        else

          {Получили номер символа (i), и теперь получаем его символ}
          char_getted := Chr(i);

          {Если капс не был нажат - перекодируем символы в маленькие русские буквы}
          if big = False then begin
            case char_getted of
              {К строке прибаляется буква; счетчик нажатых кнопок + 1; если последняя буква строки не равна такой же по индексу букве загаданного слова, то счетчик ошибок + 1;}
              'Q':begin word := word + 'й'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'W':begin word := word + 'ц'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'E':begin word := word + 'у'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'R':begin word := word + 'к'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'T':begin word := word + 'е'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Y':begin word := word + 'н'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'U':begin word := word + 'г'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'I':begin word := word + 'ш'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'O':begin word := word + 'щ'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'P':begin word := word + 'з'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ы':begin word := word + 'х'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Э':begin word := word + 'ъ'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'A':begin word := word + 'ф'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'S':begin word := word + 'ы'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'D':begin word := word + 'в'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'F':begin word := word + 'а'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'G':begin word := word + 'п'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'H':begin word := word + 'р'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'J':begin word := word + 'о'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'K':begin word := word + 'л'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'L':begin word := word + 'д'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'є':begin word := word + 'ж'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ю':begin word := word + 'э'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Z':begin word := word + 'я'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'X':begin word := word + 'ч'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'C':begin word := word + 'с'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'V':begin word := word + 'м'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'B':begin word := word + 'и'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'N':begin word := word + 'т'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'M':begin word := word + 'ь'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'ј':begin word := word + 'б'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'ѕ':begin word := word + 'ю'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'А':begin word := word + 'ё'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '1':begin word := word + '1'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '2':begin word := word + '2'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '3':begin word := word + '3'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '4':begin word := word + '4'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '5':begin word := word + '5'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '6':begin word := word + '6'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '7':begin word := word + '7'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '8':begin word := word + '8'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '9':begin word := word + '9'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '0':begin word := word + '0'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ѕ':begin word := word + '-'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '»':begin word := word + '+'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'ї':begin word := word + '.'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ь':begin word := word + '\'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
            end;
          end
          {В противном случае, - если big переменная, отвечающая а капс = true
           кодируем в большие русские буквы}
          else begin
            case char_getted of
              'Q':begin word := word + 'Й'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'W':begin word := word + 'Ц'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'E':begin word := word + 'У'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'R':begin word := word + 'К'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'T':begin word := word + 'Е'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Y':begin word := word + 'Н'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'U':begin word := word + 'Г'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'I':begin word := word + 'Ш'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'O':begin word := word + 'Щ'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'P':begin word := word + 'З'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ы':begin word := word + 'Х'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Э':begin word := word + 'Ъ'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'A':begin word := word + 'Ф'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'S':begin word := word + 'Ы'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'D':begin word := word + 'В'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'F':begin word := word + 'А'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'G':begin word := word + 'П'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'H':begin word := word + 'Р'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'J':begin word := word + 'О'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'K':begin word := word + 'Л'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'L':begin word := word + 'Д'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'є':begin word := word + 'Ж'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ю':begin word := word + 'Э'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Z':begin word := word + 'Я'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'X':begin word := word + 'Ч'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'C':begin word := word + 'С'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'V':begin word := word + 'М'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'B':begin word := word + 'И'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'N':begin word := word + 'Т'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'M':begin word := word + 'Ь'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'ј':begin word := word + 'Б'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'ѕ':begin word := word + 'Ю'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'А':begin word := word + 'Ё'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '1':begin word := word + '!'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '2':begin word := word + '"'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '3':begin word := word + '№'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '4':begin word := word + ';'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '5':begin word := word + '%'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '6':begin word := word + ':'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '7':begin word := word + '?'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '8':begin word := word + '*'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '9':begin word := word + '('; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '0':begin word := word + ')'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ѕ':begin word := word + '_'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '»':begin word := word + '='; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'ї':begin word := word + ','; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Ь':begin word := word + '/'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
            end;
          end;
      end;
      {Отрисовываем строку на лейбле}
      Label5.Caption := word;
    end;

      {Если был нажат Esc, значит exit = True, значит - уходим из цикла игры
       (Это обязательно надо делать именно на последних сроках, иначе он выйдет
        просто из цикла for, перебора клавиш, а не из цикла игры!)}
      if exit = True then begin
        break;
      end;

      {Если длинна написанного слова = длинне загаданного, то рандомится сл.
      слово меняется, обнуляются строка, которую вводил игрок}
      if length(word) = length(question) then begin
        question := words_arr[random(14) + 1];
        Label1.Caption := question;
        word := '';
        Label5.Caption := word;
      end;

      {Т.к. хадержка ниже стоит в 0.9 секунд + работа программы примерно
       0.01 секунд, прибавляем 0.1 к счетчику за каждый цикл}
      time := time + 0.1;
      {Переводим время с плавающей точкой в int, в цельные секунды}
      seconds := Round(time);

      {Если (поделить секунды на 60 с остатком, и получится 0) И (секунд > 1),
       то прибавляем к минутам + , счетчик времени и секунды обнуляем}
      if (seconds mod 60 = 0) and (time >= 1) then begin
        minutes := minutes + 1;
        time := 0;
        seconds := 0;
      end;

      {Красиво выводим время: Если (длинна переведенной в строку секунд < 2) И
      (длинна переведенной в строку минут < 2), то когда выводится время, к
      числам впереди прибавляются нули, чтобы было не как, к 1:5, а как 01:05}
      if (length(IntToStr(seconds)) < 2) and (length(IntToStr(minutes)) < 2) then begin
        Label10.Caption := '0' + IntToStr(minutes) + ' : ' + '0' + IntToStr(Round(time));
      end
      else begin
        {Далее условия для других подобных случаев...}
        if length(IntToStr(minutes)) < 2 then begin
          Label10.Caption := '0' + IntToStr(minutes) + ' : ' + IntToStr(Round(time));
        end
        else begin
          if length(IntToStr(seconds)) < 2 then begin
            Label10.Caption := IntToStr(minutes) + ' : ' + '0' + IntToStr(Round(time));
          end
          else begin
            Label10.Caption := IntToStr(minutes) + ' : ' + IntToStr(Round(time));
          end;
        end;
      end;

      if (pressed > 1) and (seconds + (minutes * 60) > 1) then begin
        {Высчитываем среднюю скорость печати}
        speed := pressed / (seconds + (minutes * 60));

        {И рисуем график}
        with Image1.Canvas do begin
          Pen.Color := clGreen;
          LineTo(10 + Round(seconds + (minutes * 60)), Image1.Height - Round(speed * 40) - 10);
          MoveTo(10 + Round(seconds + (minutes * 60)), Image1.Height - Round(speed * 40) - 10);
        end;
      end
      else begin
        {Первым делом создаем начальнюу точку откуда будем чертить первую линию}
        Image1.Canvas.MoveTo(10 + Round(seconds + (minutes * 60)), Image1.Height - Round(speed * 40) - 10);
      end;

      {Отрисовываем значения}
      Label2.Caption := IntToStr(pressed);
      Label3.Caption := IntToStr(delete_used);
      Label4.Caption := IntToStr(mistakes);
      Label12.Caption := formatfloat('0.00', speed);

      {И саму форму}
      self.Repaint;

      {Задержка, чтобы текст не дублировался + не было постоянной отрисовки}
      sleep(88);
    end;

    {При любом завершении игры отрисовываем кнопки}
    Button1.Visible := True;
    Button2.Visible := True;
    Button3.Visible := True;
    Button4.Visible := True;
end;


procedure TForm2.Button2Click(Sender: TObject);
begin
  {При выходе скрывается текущая форма, открывается изначальная}
  Form1.Visible := True;
  Form2.Visible := False;

  {Активируется кнопка очистки}
  Button3Click(Sender);
end;

procedure TForm2.FormCreate(Sender: TObject);
var i, x, y, sch: Integer;
begin
  with Image1.Canvas do begin
    Pen.Color := clRed;

    {Вертикальная линия}
    MoveTo(10, Image1.Height - 10);
    LineTo(Image1.Width - 10, Image1.Height - 10);

    {Горизонтальная линия}
    MoveTo(10, 10);
    LineTo(10, Image1.Height - 10);

    {Черточки со значениями для горизонтальной линии}
    x := 40;
    while x < Image1.Width - 30 do begin
      MoveTo(x , Image1.Height - 15);
      LineTo(x, Image1.Height - 5);
      TextOut(x - 5, Image1.Height - 30, IntToStr(x));
      x := x + 40;
    end;

    {Для вертикальной}
    y := 40;
    sch := 1;
    while y < Image1.Height - 20 do begin
      MoveTo(5, Image1.Height - y);
      LineTo(15, Image1.Height - y);
      TextOut(20, Image1.Height - y - 5, IntToStr(sch));
      sch := sch + 1;
      y := y + 40;
    end;
  end;
end;


procedure TForm2.Button3Click(Sender: TObject);
begin
  {Закрашиваем все белым}
  Image1.Canvas.Pen.Color := clWhite;
  Image1.Canvas.Rectangle(0, 0, Image1.Width,Image1.Height);

  {Вызываем процедуру, где рисуются линии}
  FormCreate(Sender);

  {Обнуляем счетчики}
  Label2.Caption := '0';
  Label3.Caption := '0';
  Label4.Caption := '0';
  Label10.Caption := '00 : 00';
  Label12.Caption := '0';
  {И текст}
  Label1.Caption := '*Здесь будет выводиться текст';
  Label5.Caption := '';
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  {При закрытии главной формы - закрывается и вся программа}
  Form1.close;
end;

end.
