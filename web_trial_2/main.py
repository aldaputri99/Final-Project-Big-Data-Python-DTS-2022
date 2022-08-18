from datetime import timedelta
from flask import Flask, render_template, url_for, redirect, request, session, app, flash
from flask_mysqldb import MySQL
import sqlalchemy as sqla
import pandas as pd
import plotly
import plotly.express as px
import json
import itertools
#import re

app = Flask(__name__)
app.secret_key = "asdfghjkl12345fdsa_fdsakld8rweodfds"

#mysql config
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'db_quithon'
mysql = MySQL(app)


#untuk disable button question 
def set_status(quest_list):
    q_attempt = []
    strval = session['result'].strip()
    ans = strval.split(',')
    
    for i in range(int(len(ans)/2)):
        q_attempt.append(int(ans[2*i]))
    print(q_attempt)
    
    q_list = [list(q) for q in quest_list] #change nested tuple to nested list
    for q in q_list:
        if q[0] in q_attempt:
            #q[8] = 'bg-success' #set color btncol
            q[9] = 'disabled' # disable status

    return tuple(tuple(q) for q in q_list)

# transform db table nilai to pandas dataframe
def get_db_as_df(sid):
    try:
        sqla_conn = sqla.create_engine("mysql+mysqldb://root:@localhost/db_quithon")
        query = 'SELECT * FROM GRADE WHERE SID = {}'.format(sid)
        df_nilai = pd.read_sql(query, con=sqla_conn, parse_dates=['done'])
        return df_nilai
    except:
        return 'Failed to fetch dataframe from DB'

#set session timeout
@app.before_request
def make_session_permanent():
    session.permanent = True
    app.permanent_session_lifetime = timedelta(minutes=60)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/login', methods=['GET', 'POST'])       
def login_student():
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT * FROM STUDENT''')
    user = cursor.fetchall()
    cursor.close()

    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        for u in user:
            if email in u and password == u[2]:
                session['logged_in'] = True
                session['name'] = u[3]
                session['sid'] = u[0]
            return redirect(url_for('index'))

    return render_template('login_student.html')

@app.route('/login-teacher')       
def login_teacher():
    return render_template('login_teacher.html')

@app.route('/logout')
def logout():
    session.pop('logged_in', False)
    session.pop('name', None)
    return redirect(url_for('login_student'))

@app.route('/quiz')       
def get_all_quiz():
    session['result'] = ""
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT DISTINCT SUBJECT FROM QUIZ ORDER BY SUBJECT''')
    sub_list = cursor.fetchall()
    cursor.close()
    
    return render_template('quiz_list.html', sub_list=sub_list)

@app.route('/quiz/<string:subject>')
def get_quiz(subject):
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT QID FROM QUIZ WHERE subject = %s''', (subject, ))
    qid = cursor.fetchone()
    cursor.execute('''SELECT COUNT(*) FROM QUIZ WHERE subject = %s''', (subject, ))
    quest_total = cursor.fetchone()
    cursor.close()
    return render_template("quiz.html",subject=subject, qid=int(qid[0]), quest_total=int(quest_total[0]))

@app.route('/quiz/<string:subject>#<int:qid>')       
def get_quest(subject, qid):
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT * FROM QUIZ WHERE subject = %s''', (subject, ))
    quest_list = cursor.fetchall()
    cursor.execute('''SELECT * FROM QUIZ WHERE qid = %s''', (qid, ))
    quest = cursor.fetchone()
    cursor.close()

    quest_list = set_status(quest_list)
    return render_template("quiz_quest.html",quest_list=quest_list, quest=quest)

@app.route('/save-answer', methods=["POST"]) 
def save_answer():
    #if request.method == 'POST':
    qid = request.form['qid']
    answer = request.form['answer']
    subject = request.form['subject']

    session['result'] += qid+','+answer+','
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT * FROM QUIZ WHERE subject = %s''', (subject, ))
    quest_list = cursor.fetchall()
    cursor.execute('''SELECT * FROM QUIZ WHERE qid = %s''', (qid, ))
    quest = cursor.fetchone()
    cursor.close()
    quest_list = set_status(quest_list)
    #return redirect (url_for('get_quest', subject=subject, qid=qid))
    #print(quest)
    #print(quest_list)
    #print(session['result'])
    return render_template("quiz_quest.html",quest_list=quest_list, quest=quest)  
        
@app.route("/finish/<string:subject>")
def finish(subject):
    #calculate result
    count = 0
    strval = session['result'].strip()

    #split result string by ','
    answer = strval.split(',')
    print(answer)

    for i in range(len(answer)//2):
        qd = answer[2*i] # get question id
        qn = answer[2*i+1]  # get the corresponding answer
        tt = int(qd)
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT ANSWER FROM QUIZ WHERE qid = %s''', (tt, ))
        actans = cursor.fetchone()
        cursor.close()
        if actans[0] == int(qn): #compare correct answer in questions table with answer chosen by user
            count += 1 # increment counter

    soal = len(answer)//2
    skor = count/soal * 100
    txt = f'Anda berhasil menjawab {count} dari {soal} soal.'
    txt_skor = f'{skor:.1f}'
    
    sid = session['sid']
    cursor = mysql.connection.cursor()
    cursor.execute('''INSERT INTO grade(subject,sid,score) VALUES(%s,%s,%s)''',(subject,sid,skor))
    mysql.connection.commit()
    cursor.close()

    return render_template("quiz_result.html",txt=txt,txt_skor=txt_skor)

@app.route('/grade')
def get_grade():
    sid = session['sid']
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT * FROM GRADE WHERE sid = %s''', (sid, ))
    grade_list = cursor.fetchall()
    cursor.close()

    return render_template("grade_student.html", grade_list=grade_list)

@app.route('/grade/plot')
def get_grade_plot():
    df = get_db_as_df(session['sid'])
    df_nilai = df[['subject','score','done']]

    fig = px.bar(df_nilai, x='done', y='score', color='subject', barmode='group', width=1100, height=500, labels={"done": "Tanggal Pengerjaan",  "score": "Skor", "subject": "Judul Kuis"})
    graph_json = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)
    print(df)

    return render_template('grade_student_plot.html', graph_json=graph_json)

@app.route('/materi')       
def get_materi():
    return render_template('materi_list.html')

@app.route('/materi/Dasar Python 1')       
def get_materi_dp1():
    return render_template('materi_dp_1.html')

@app.route('/materi/Dasar Python 2')       
def get_materi_dp2():
    return render_template('materi_dp_2.html')

@app.route('/materi/Dasar Python 3')       
def get_materi_dp3():
    return render_template('materi_dp_3.html')

@app.route('/materi/Dasar Python 4')       
def get_materi_dp4():
    return render_template('materi_dp_4.html')

if __name__ == '__main__':
    app.run(debug=True)